require_relative 'parity_matrix'

include Math

module ScGen
  def parity_pattern_gen(matrix)
    print_width1  = "matrix[#{matrix.parity_width - 1}]".size.round_up4
    print_width2  = (matrix.data_width + 3) / 4

    matrix.each_with_index {|row, i|
      printf(
        "    %-*s= 0x%0*x;\n",
        print_width1, "matrix[#{i}]",
        print_width2, row
      )
    }
  end
  module_function :parity_pattern_gen

  def syndrome_pattern_gen(matrix)
    syndrome      = Syndrome.new(matrix)
    print_width1  = log10(syndrome.size).ceil
    print_width2  = (matrix.parity_width + 3) / 4
    print_width3  = (matrix.code_width   + 3) / 4

    syndrome.each_with_index {|syn, i|
      printf(
        "    pattern[%-*d].set(0x%0*x, 0x%0*x);\n",
        print_width1, i,
        print_width2, syn.syndrome,
        print_width3, syn.error_pattern
      )
    }
  end
  module_function :syndrome_pattern_gen
end

if $0 == __FILE__ then
  data_width  = ARGV[0].to_i
  error_num   = ARGV[1].to_i
  extend_on   = (ARGV[2].downcase == "true")
  matrix      = ParityMatrix.new(data_width, error_num, extend_on)

  printf("code width   = %d\n", matrix.code_width)
  printf("data wdith   = %d\n", matrix.data_width)
  printf("parity width = %d\n", matrix.parity_width)

  ScGen.parity_pattern_gen(matrix)
  ScGen.syndrome_pattern_gen(matrix)
end
