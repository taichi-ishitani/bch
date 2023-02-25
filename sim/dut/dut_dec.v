`ifndef dDataWidth
`define dDataWidth  16
`endif

`ifndef dErrorNum
`define dErrorNum   1
`endif

`ifndef dExtendOn
`define dExtendOn   1
`endif

module dut_dec #(
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
    input                       i_code_valid,
    input   [pCodeWidth-1:0]    i_code,
    output                      o_data_valid,
    output  [pDataWidth-1:0]    o_data,
    output                      o_corrected,
    output                      o_detected
);
    `include "bch_common_function.vh"

    bch_dec #(
        .pDataWidth (pDataWidth ),
        .pErrorNum  (pErrorNum  ),
        .pExtendOn  (pExtendOn  )
    ) u_dec (
        .clk            (clk            ),
        .rst_x          (rst_x          ),
        .i_enable       (i_enable       ),
        .i_code_valid   (i_code_valid   ),
        .i_code         (i_code         ),
        .o_data_valid   (o_data_valid   ),
        .o_data         (o_data         ),
        .o_corrected    (o_corrected    ),
        .o_detected     (o_detected     )
    );
endmodule
