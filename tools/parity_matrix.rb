class Fixnum
  def bit_width
    temp  = self
    width = 0
    while temp != 0 do
      temp  /= 2
      width += 1
    end
    return width
  end

  def round_up4
    return self + (4 - (self % 4))
  end
end

class ParityMatrix
  class GeneratingPoynomial
    def initialize(polynomial, error_num, data_range)
      @polynomial   = polynomial
      @error_num    = error_num
      @data_range   = data_range
      @parity_width = polynomial.bit_width - 1
    end
    attr_reader :polynomial
    attr_reader :error_num
    attr_reader :parity_width
    attr_reader :data_range

    def mod(x)
      y       = @polynomial
      x_width = x.bit_width
      y_width = y.bit_width
      while x_width >= y_width do
        x       ^= (y << (x_width - y_width))
        x_width = x.bit_width
      end
      return x
    end
  end

  @@generating_polynomial     = Array.new

  # g(x) = x^10 + x^9 + x^8 + x^6 + x^5 + x^3 + x^0
  @@generating_polynomial << GeneratingPoynomial.new(0b11101101001, 2, (8 .. 21))
  # g(x) = x^12 + x^10 + x^8 + x^5 + x^4 + x^3 + x^0
  @@generating_polynomial << GeneratingPoynomial.new(0b1010100111001, 2, (22 .. 51))
  # g(x) = x^5 + x^2 + x^0
  @@generating_polynomial << GeneratingPoynomial.new(0b100101, 1, (13 .. 26))
  # g(x) = x^6 + x^1 + x^0
  @@generating_polynomial << GeneratingPoynomial.new(0b1000011, 1, (27 .. 57))

  include Enumerable

  def initialize(width, error_num, extend_on)
    @data_width = width
    get_parity_matrix(width, error_num, extend_on)
  end

  attr_reader :data_width
  attr_reader :polynomial

  def parity_width
    return @parity_matrix.size
  end

  def code_width
    return @data_width + parity_width
  end

  def each(&block)
    @parity_matrix.each {|row|
      block.call(row)
    }
  end

  def [](row, column = nil)
    if column.nil? then
      return @parity_matrix[row]
    else
      return @parity_matrix[row][column]
    end
  end

  def get_parity_matrix(width, error_num, extend_on)
    @polynomial   = @@generating_polynomial.find {|pol|
      pol.data_range === width && pol.error_num == error_num
    }
    @parity_width = @polynomial.parity_width
    matrix        = Array.new

    # 生成行列の作成
    width.times {|w|
      x = 2 ** (w + @polynomial.parity_width)
      matrix  << @polynomial.mod(x)
    }

    # パリティ行列の作成
    @parity_matrix  = Array.new(@polynomial.parity_width, 0)
    matrix.each_with_index {|row, i|
      @polynomial.parity_width.times {|j|
        @parity_matrix[j] |= (row[j] << i)
      }
    }

    # 拡大符号の作成
    if extend_on then
      additional  = 2 ** width - 1
      @parity_matrix.each {|row|
        additional  ^= row
      }
      @parity_matrix.unshift(additional)
    end
  end
  private :get_parity_matrix
end

class Syndrome
  class SyndromePattern
    def initialize(pattern, matrix)
      @error_pattern  = pattern
      @syndrome       = calc_syndrome(pattern, matrix)
    end
    attr_reader :error_pattern
    attr_reader :syndrome

    def calc_syndrome(pattern, matrix)
      value = 0
      matrix.each_with_index {|row, i|
        temp  = pattern & ((row << matrix.parity_width) | (2 ** i))

        bit   = 0
        temp.bit_width.times {|j|
          bit ^= temp[j]
        }
        value |= (bit << i)
      }
      return value
    end
  end

  include Enumerable

  def initialize(matrix)
    @syndrome = Array.new
    1.upto(matrix.polynomial.error_num) {|e|
      error_pattern_gen(matrix.code_width, e).each {|pattern|
        @syndrome << SyndromePattern.new(pattern, matrix)
      }
    }
  end

  def each(&block)
    @syndrome.each {|syndrome|
      block.call(syndrome)
    }
  end

  def size
    return @syndrome.size
  end

  def error_pattern_gen(w, e)
    pattern = Array.new
    if e == 1 then
      w.times {|i|
        pattern << (2 ** i)
      }
    else
      w.times {|i|
        error_pattern_gen(i, e - 1).each {|temp|
          pattern << (temp | (2 ** i))
        }
      }
    end
    return pattern
  end
  private :error_pattern_gen
end

if $0 == __FILE__ then
  matrix  = ParityMatrix.new(21, 2, true)
  matrix.each_with_index {|row, i|
    printf("row = %021b (%d)\n", row, i)
  }
  Syndrome.new(matrix).each {|syndrome|
    printf("pattern : %032b syndrome : %011b\n", syndrome.error_pattern, syndrome.syndrome)
  }
end