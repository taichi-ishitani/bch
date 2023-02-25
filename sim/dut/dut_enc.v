`ifndef dDataWidth
`define dDataWidth  16
`endif

`ifndef dErrorNum
`define dErrorNum   1
`endif

`ifndef dExtendOn
`define dExtendOn   1
`endif

module dut_enc #(
    parameter   pDataWidth  = `dDataWidth,
    parameter   pErrorNum   = `dErrorNum,
    parameter   pExtendOn   = `dExtendOn,
    parameter   pCodeWidth  = get_code_width (
                                pDataWidth,
                                pErrorNum,
                                pExtendOn
                              )
)(
    input                       clk,
    input                       rst_x,
    input                       i_enable,
    input                       i_data_valid,
    input   [pDataWidth-1:0]    i_data,
    output                      o_code_valid,
    output  [pCodeWidth-1:0]    o_code
);
    `include "bch_common_function.vh"

    bch_enc #(
        .pDataWidth (pDataWidth ),
        .pErrorNum  (pErrorNum  ),
        .pExtendOn  (pExtendOn  )
    ) u_enc (
        .clk            (clk            ),
        .rst_x          (rst_x          ),
        .i_enable       (i_enable       ),
        .i_data_valid   (i_data_valid   ),
        .i_data         (i_data         ),
        .o_code_valid   (o_code_valid   ),
        .o_code         (o_code         )
    );

endmodule
