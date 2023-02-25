/**
 *  @file   bch_enc.v
 *  @brief  BCH符号エンコーダ
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/31  T. Ishitani     coding start
 *  @data   0.0.01  2012/06/03  T. Ishtiani     パリティ生成/検査行列計算を共通化
 */
module bch_enc #(
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
    input                               i_enable,                       //!<    符号化イネーブル
    input                               i_data_valid,                   //!<    入力データバリッド
    input       [pDataWidth-1:0]        i_data,                         //!<    入力データ
    output                              o_code_valid,                   //!<    出力コードバリッド
    output      [pCodeWidth-1:0]        o_code                          //!<    出力コード
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
    wire        [lpParityWidth-1:0]     w_parity;
    wire        [lpDelayWidth-1:0]      w_delay_in;
    wire        [lpDelayWidth-1:0]      w_delay_out;

//----------------------------------------------------------------------
//  パリティ生成
//----------------------------------------------------------------------
    assign  o_code_valid    = w_delay_out[0];
    assign  o_code          = {w_delay_out[lpDelayWidth-1:1], w_parity};

    bch_calc_matrix #(
        .pDataWidth     (pDataWidth     ),
        .pParityWidth   (lpParityWidth  ),
        .pCodeWidth     (pCodeWidth     ),
        .pParityMode    (1              )
    ) u_parity_generator (
        .clk            (clk            ),
        .rst_x          (rst_x          ),
        .i_enable       (i_enable       ),
        .i_valid        (i_data_valid   ),
        .i_in           (i_data         ),
        .o_result       (w_parity       )
    );

    //  遅延調整
    assign  w_delay_in  = {i_data, i_data_valid};

    bch_delay #(
        .pWidth (lpDelayWidth   ),
        .pDelay (1              )
    ) u_delay (
        .clk    (clk            ),
        .rst_x  (rst_x          ),
        .i_d    (w_delay_in     ),
        .o_d    (w_delay_out    )
    );

endmodule
