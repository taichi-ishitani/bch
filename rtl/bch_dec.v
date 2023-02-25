/**
 *  @file   bch_dec.v
 *  @brief  BCH符号デコーダ
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/31  T. Ishitani     coding start
 *  @data   0.0.01  2012/06/03  T. Ishtiani     パリティ生成/検査行列計算を共通化
 */
module bch_dec #(
//--type-------+name-------------------+value--------------------------+description
    parameter   pDataWidth              = 16,                           //!<    データ幅
    parameter   pErrorNum               = 2,                            //!<    訂正可能エラービット数
    parameter   pExtendOn               = 1,                            //!<    拡張符号化On/Off
    parameter   pCodeWidth              = get_code_width (              //!<    出力コード幅
                                            pDataWidth,
                                            pErrorNum,
                                            pExtendOn
                                          )
)(
//--type-------+width------------------+name---------------------------+description
    input                               clk,                            //!<    クロック
    input                               rst_x,                          //!<    非同期リセット
    input                               i_enable,                       //!<    復号化イネーブル
    input                               i_code_valid,                   //!<    入力コードイネーブル
    input       [pCodeWidth-1:0]        i_code,                         //!<    入力コード
    output                              o_data_valid,                   //!<    出力データバリッド
    output      [pDataWidth-1:0]        o_data,                         //!<    出力データ
    output                              o_corrected,                    //!<    エラー訂正
    output                              o_detected                      //!<    エラー検出
);

    //  共通関数インクルード
    `include "bch_common_function.vh"

//--type-------+name-------------------+value--------------------------+description
    localparam  lpParityWidth           = get_parity_width (            //!<    パリティ幅
                                            pDataWidth,
                                            pErrorNum,
                                            pExtendOn
                                          );
    localparam  lpDelayWidth            = pDataWidth + 1;               //!<    遅延データ幅

//--type-------+width------------------+name---------------------------+description
    wire        [lpParityWidth-1:0]     w_syndrome;
    wire                                w_code_valid;
    wire        [pDataWidth-1:0]        w_code;
    wire        [lpDelayWidth-1:0]      w_delay_in;
    wire        [lpDelayWidth-1:0]      w_delay_out;

//----------------------------------------------------------------------
//  シンドローム生成
//----------------------------------------------------------------------
    bch_calc_matrix #(
        .pDataWidth     (pDataWidth     ),
        .pParityWidth   (lpParityWidth  ),
        .pCodeWidth     (pCodeWidth     ),
        .pParityMode    (0              )
    ) u_syndrome_generator (
        .clk            (clk            ),
        .rst_x          (rst_x          ),
        .i_enable       (i_enable       ),
        .i_valid        (i_code_valid   ),
        .i_in           (i_code         ),
        .o_result       (w_syndrome     )
    );

    //  遅延調整
    assign  w_delay_in      = {i_code[pCodeWidth-1-:pDataWidth], i_code_valid};
    assign  w_code_valid    = w_delay_out[0];
    assign  w_code          = w_delay_out[lpDelayWidth-1:1];

    bch_delay #(
        .pWidth (lpDelayWidth   ),
        .pDelay (1              )
    ) u_delay (
        .clk    (clk            ),
        .rst_x  (rst_x          ),
        .i_d    (w_delay_in     ),
        .o_d    (w_delay_out    )
    );

//----------------------------------------------------------------------
//  エラー検査/訂正
//----------------------------------------------------------------------
    bch_check_error #(
        .pDataWidth     (pDataWidth     ),
        .pParityWidth   (lpParityWidth  ),
        .pCodeWidth     (pCodeWidth     ),
        .pErrorNum      (pErrorNum      )
    ) u_check_error (
        .clk            (clk            ),
        .rst_x          (rst_x          ),
        .i_code_valid   (w_code_valid   ),
        .i_code         (w_code         ),
        .i_syndrome     (w_syndrome     ),
        .o_data_valid   (o_data_valid   ),
        .o_data         (o_data         ),
        .o_corrected    (o_corrected    ),
        .o_detected     (o_detected     )
    );

endmodule
