/**
 *  @file   bch_check_error.v
 *  @brief  エラー検査/訂正
 *
 *  @par    Copyright
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/06/03  T. Ishitani     coding start
 */
module bch_check_error #(
//--type-------+name-------------------+value--------------------------+description
    parameter   pDataWidth              = 16,                           //!<    データ幅
    parameter   pParityWidth            = 11,                           //!<    パリティ幅
    parameter   pCodeWidth              = 27,                           //!<    コード幅
    parameter   pErrorNum               = 2                             //!<    訂正可能エラー数
)(
//--type-------+width------------------+name---------------------------+description
    input                               clk,                            //!<    クロック
    input                               rst_x,                          //!<    非同期リセット
    input                               i_code_valid,                   //!<    入力コードバリッド
    input       [pDataWidth-1:0]        i_code,                         //!<    入力コード(データ部のみ)
    input       [pParityWidth-1:0]      i_syndrome,                     //!<    シンドローム
    output                              o_data_valid,                   //!<    出力データバリッド
    output      [pDataWidth-1:0]        o_data,                         //!<    出力データ
    output                              o_corrected,                    //!<    エラー訂正
    output                              o_detected                      //!<    エラー検出(訂正不可)
);

    //  共通関数インクルード
    `include "bch_common_function.vh"

    //  パターン選択関数インクルード
    `include "bch_27_16.vh"
    `include "bch_45_32.vh"
    `include "hamming_22_16.vh"
    `include "hamming_39_32.vh"

//--type-------+name-------------------+value--------------------------+description
    localparam  lpTotalErrorNum         = calc_pattern_num(             //!<    総エラー数
                                            pCodeWidth,
                                            pErrorNum
                                          );
    localparam  lpParityErrorNum        = calc_pattern_num(             //!<    パリティ部エラー数
                                            pParityWidth,
                                            pErrorNum
                                          );
    localparam  lpPatternWidth          = pDataWidth + 1;               //!<    エラーパターン幅

//--type-------+width------------------+name---------------------------+description
    wire        [lpTotalErrorNum-1:0]   w_decoded_syndrome;
    wire                                w_error;
    reg                                 r_error;
    wire        [lpPatternWidth-1:0]    w_pattern;
    reg         [lpPatternWidth-1:0]    r_pattern;
    reg                                 r_code_valid;
    reg         [pDataWidth-1:0]        r_code;
    wire        [pDataWidth-1:0]        w_data;
    wire                                w_corrected;
    wire                                w_detected;
    reg                                 r_data_valid;
    reg         [pDataWidth-1:0]        r_data;
    reg                                 r_corrected;
    reg                                 r_detected;

//----------------------------------------------------------------------
//  エラー検査
//----------------------------------------------------------------------
    assign  w_error         = |i_syndrome;
    assign  w_pattern[0]    = |w_decoded_syndrome[lpParityErrorNum-1:0];
    generate
        if ((pCodeWidth == 27) && (pDataWidth == 16)) begin : bch_27_16
            assign  w_decoded_syndrome              = f_decode_syndrome_bch_27_16(i_syndrome);
            assign  w_pattern[lpPatternWidth-1:1]   = f_select_pattern_bch_27_16(
                                                        w_decoded_syndrome[lpTotalErrorNum-1:lpParityErrorNum]
                                                      );
        end
        else if ((pCodeWidth == 45) && (pDataWidth == 32)) begin : bch_45_32
            assign  w_decoded_syndrome              = f_decode_syndrome_bch_45_32(i_syndrome);
            assign  w_pattern[lpPatternWidth-1:1]   = f_select_pattern_bch_45_32(
                                                        w_decoded_syndrome[lpTotalErrorNum-1:lpParityErrorNum]
                                                      );
        end
        else if ((pCodeWidth == 22) && (pDataWidth == 16)) begin : hamming_22_16
            assign  w_decoded_syndrome              = f_decode_syndrome_hamming_22_16(i_syndrome);
            assign  w_pattern[lpPatternWidth-1:1]   = w_decoded_syndrome[lpTotalErrorNum-1:lpParityErrorNum];
        end
        else if ((pCodeWidth == 39) && (pDataWidth == 32)) begin : hamming_39_32
            assign  w_decoded_syndrome              = f_decode_syndrome_hamming_39_32(i_syndrome);
            assign  w_pattern[lpPatternWidth-1:1]   = w_decoded_syndrome[lpTotalErrorNum-1:lpParityErrorNum];
        end
    endgenerate

    always @(posedge clk or negedge rst_x) begin
        if (!rst_x) begin
            r_error         <= 1'b0;
            r_pattern       <= {lpPatternWidth{1'b0}};
            r_code_valid    <= 1'b0;
            r_code          <= {pDataWidth{1'b0}};
        end
        else begin
            r_error         <= w_error;
            r_pattern       <= w_pattern;
            r_code_valid    <= i_code_valid;
            r_code          <= i_code;
        end
    end

//----------------------------------------------------------------------
//  エラー訂正/ステータス生成
//----------------------------------------------------------------------
    assign  o_data_valid    = r_data_valid;
    assign  o_data          = r_data;
    assign  o_corrected     = r_corrected;
    assign  o_detected      = r_detected;

    assign  w_data          = r_code ^ r_pattern[lpPatternWidth-1:1];
    assign  w_corrected     = |r_pattern;
    assign  w_detected      = r_error & (~w_corrected);
    always @(posedge clk or negedge rst_x) begin
        if (!rst_x) begin
            r_data_valid    <= 1'b0;
            r_data          <= {pDataWidth{1'b0}};
            r_corrected     <= 1'b0;
            r_detected      <= 1'b0;
        end
        else begin
            r_data_valid    <= r_code_valid;
            r_data          <= w_data;
            r_corrected     <= w_corrected;
            r_detected      <= w_detected;
        end
    end

endmodule
