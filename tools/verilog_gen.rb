require_relative 'parity_matrix'

include Math

module VerilogGen
  def calc_parity_function(matrix)
    code_name     = (matrix.polynomial.error_num == 1) ? "hamming" : "bch"
    function_name = "f_calc_parity_#{code_name}_#{matrix.code_width}_#{matrix.data_width}"
    print_width1  = function_name.length.round_up4
    print_width2  = (matrix.data_width + 3) / 4

    code  = []
    code  << sprintf("%-*s= {", print_width1, function_name)
    (matrix.parity_width - 1).downto(0) {|i|
      row       = matrix[i]
      row_code  = []
      last      = (i == 0) ? true : false
      (matrix.data_width - 1).downto(0) {|j|
        row_code  << "i_d[#{j}]"  if row[j] == 1
      }
      code  << "    ^{#{row_code.join(', ')}}" + ((last) ? "" : ",") + sprintf("// 0x%-0*x", print_width2, row)
    }
    code  << "};"
    printf("%s\n", code.join("\n"))
  end
  module_function :calc_parity_function

  def decode_syndrome_function(matrix)
    syndrome      = Syndrome.new(matrix)
    code_name     = (matrix.polynomial.error_num == 1) ? "hamming" : "bch"
    function_name = "f_decode_syndrome_#{code_name}_#{matrix.code_width}_#{matrix.data_width}"
    print_width1  = function_name.length.round_up4
    print_width2  = (matrix.parity_width + 3) / 4
    code          = []

    code  << sprintf("%-*s= {", print_width1, function_name)
    syndrome.select {|syn| syn.syndrome != syn.error_pattern}.reverse.each {|syn|
      code  << sprintf("    ((i_syn == %d'h%0*x) ? 1'b1 : 1'b0),", matrix.parity_width, print_width2, syn.syndrome)
    }
    temp  = syndrome.select {|syn| syn.syndrome == syn.error_pattern}.reverse
    temp.each_with_index {|syn, i|
          last  = (i == (temp.size - 1)) ? true : false
          code  << sprintf("    ((i_syn == %d'h%0*x) ? 1'b1 : 1'b0)", matrix.parity_width, print_width2, syn.syndrome) + ((last) ? "" : ",")
    }
    code  << "};"
    printf("%s\n", code.join("\n"))
  end
  module_function :decode_syndrome_function

  def select_pattern_function(matrix)
    syndrome      = Syndrome.new(matrix)
    code_name     = (matrix.polynomial.error_num == 1) ? "hamming" : "bch"
    function_name = "f_select_pattern_#{code_name}_#{matrix.code_width}_#{matrix.data_width}"
    code          = []

    temp  = syndrome.select {|syn| syn.syndrome != syn.error_pattern}
    print_width1  = function_name.length.round_up4
    print_width2  = log10(temp.size).ceil
    print_width3  = (matrix.data_width   + 3) / 4
    print_width4  = (matrix.parity_width + 3) / 4
    (temp.size - 1).downto(0) {|i|
      syn   = temp[i]
      first = (i == (temp.size - 1))
      last  = (i == 0)
      if first then
        code  << sprintf(
          "%-*s= ({%d{i_sel[%-*d]}} & %d'h%0*x)  //  syndrome : 0x%0*x",
          print_width1, function_name,
          matrix.data_width,
          print_width2, i,
          matrix.data_width, print_width3, (syn.error_pattern >> matrix.parity_width),
          print_width4, syn.syndrome
        )
      elsif !last then
        code  << sprintf(
          "%-*s| ({%d{i_sel[%-*d]}} & %d'h%0*x)  //  syndrome : 0x%0*x",
          print_width1, "",
          matrix.data_width,
          print_width2, i,
          matrix.data_width, print_width3, (syn.error_pattern >> matrix.parity_width),
          print_width4, syn.syndrome
        )
      else
        code  << sprintf(
          "%-*s| ({%d{i_sel[%-*d]}} & %d'h%0*x); //  syndrome : 0x%0*x",
          print_width1, "",
          matrix.data_width,
          print_width2, i,
          matrix.data_width, print_width3, (syn.error_pattern >> matrix.parity_width),
          print_width4, syn.syndrome
        )
      end
    }
    printf("%s\n", code.join("\n"))
  end
  module_function :select_pattern_function
end

if $0 == __FILE__ then
  data_width  = ARGV[0].to_i
  error_num   = ARGV[1].to_i
  extend_on   = (ARGV[2].downcase == "true")
  matrix      = ParityMatrix.new(data_width, error_num, extend_on)

  printf("code width   = %d\n", matrix.code_width)
  printf("data wdith   = %d\n", matrix.data_width)
  printf("parity width = %d\n", matrix.parity_width)

  VerilogGen.calc_parity_function(matrix)
  VerilogGen.decode_syndrome_function(matrix)
  VerilogGen.select_pattern_function(matrix)
end
