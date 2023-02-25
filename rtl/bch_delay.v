/**
 *  @file   bch_delay.v
 *  @brief  nクロック遅延
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/30  T. Ishitani     coding start
 */
module bch_delay #(
//--type-------+name-------------------+value--------------------------+description
    parameter   pWidth                  = 8,                            //!<    データ幅
    parameter   pDelay                  = 8                             //!<    遅延量
)(
//--type-------+width------------------+name---------------------------+description
    input                               clk,                            //!<    クロック
    input                               rst_x,                          //!<    非同期リセット
    input       [pWidth-1:0]            i_d,                            //!<    入力データ
    output      [pWidth-1:0]            o_d                             //!<    出力データ(pDelayクロック遅延)
);

//--type-------+width------------------+name---------------------------+description
    reg         [pWidth-1:0]            r_d[0:pDelay-1];                //!<    遅延バッファ

    assign  o_d = r_d[pDelay-1];

    genvar  i;
    generate
        for (i = 0; i < pDelay; i = i + 1) begin : delay_loop
            if (i == 0) begin : eq_0
                always @(posedge clk or negedge rst_x) begin
                    if (!rst_x) begin
                        r_d[i]  <= {pWidth{1'b0}};
                    end
                    else begin
                        r_d[i]  <= i_d;
                    end
                end
            end
            else begin : ne_0
                always @(posedge clk or negedge rst_x) begin
                    if (!rst_x) begin
                        r_d[i]  <= {pWidth{1'b0}};
                    end
                    else begin
                        r_d[i]  <= r_d[i-1];
                    end
                end
            end
        end
    endgenerate

endmodule
