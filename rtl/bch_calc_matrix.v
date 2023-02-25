/**
 *  @file   bch_calc_matrix.v
 *  @brief  パリティ生成/検査行列計算
 *
 *  @par    Copyright
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/06/03  T. Ishitani     coding start
 */
module bch_calc_matrix #(
//--type-------+name-------------------+value--------------------------+description
    parameter   pDataWidth              = 16,                           //!<    データ幅
    parameter   pParityWidth            = 11,                           //!<    パリティ幅
    parameter   pCodeWidth              = 27,                           //!<    コード幅
    parameter   pParityMode             = 1,                            //!<    生成モード(1:パリティ 0:シンドローム)
    parameter   pInWidth                = (pParityMode != 0)            //!<    入力幅
                                        ? pDataWidth
                                        : pCodeWidth
)(
//--type-------+width------------------+name---------------------------+description
    input                               clk,                            //!<    クロック
    input                               rst_x,                          //!<    非同期リセット
    input                               i_enable,                       //!<    イネーブル
    input                               i_valid,                        //!<    入力バリッド
    input       [pInWidth-1:0]          i_in,                           //!<    入力データ/コード
    output      [pParityWidth-1:0]      o_result                        //!<    計算結果(パリティ/シンドローム)
);

//--type-------+width------------------+name---------------------------+description
    wire        [pDataWidth-1:0]        w_data;
    wire        [pParityWidth-1:0]      w_parity;
    wire        [pParityWidth-1:0]      w_result;
    reg         [pParityWidth-1:0]      r_result;

    //  パリティ計算関数インクルード
    `include "bch_27_16.vh"
    `include "bch_45_32.vh"
    `include "hamming_22_16.vh"
    `include "hamming_39_32.vh"

//----------------------------------------------------------------------
//  パリティ計算
//----------------------------------------------------------------------
    generate
        if (pParityMode != 0) begin : data_sel_parity
            assign  w_data      = i_in;
        end
        else begin : data_sel_syndrome
            assign  w_data      = i_in[pCodeWidth-1:pParityWidth];
        end
    endgenerate

    generate
        if ((pCodeWidth == 27) && (pDataWidth == 16)) begin : bch_27_16
            assign  w_parity    = f_calc_parity_bch_27_16(w_data);
        end
        else if ((pCodeWidth == 45) && (pDataWidth == 32)) begin : bch_45_32
            assign  w_parity    = f_calc_parity_bch_45_32(w_data);
        end
        else if ((pCodeWidth == 22) && (pDataWidth == 16)) begin : hamming_22_16
            assign  w_parity    = f_calc_parity_hamming_22_16(w_data);
        end
        else if ((pCodeWidth == 39) && (pDataWidth == 32)) begin : hamming_39_32
            assign  w_parity    = f_calc_parity_hamming_39_32(w_data);
        end
    endgenerate

//----------------------------------------------------------------------
//  出力
//----------------------------------------------------------------------
    assign  o_result    = r_result;

    generate
        if (pParityMode != 0) begin : result_sel_parity
            assign  w_result    = w_parity;
        end
        else begin : result_sel_syndrome
            assign  w_result    = w_parity ^ i_in[pParityWidth-1:0];
        end
    endgenerate

    always @(posedge clk or negedge rst_x) begin
        if (!rst_x) begin
            r_result    <= {pParityWidth{1'b0}};
        end
        else if (i_enable && i_valid) begin
            r_result    <= w_result;
        end
        else begin
            r_result    <= {pParityWidth{1'b0}};
        end
    end

endmodule
