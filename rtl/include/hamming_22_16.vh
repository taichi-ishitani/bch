/**
 *  @file   hamming_22_16.vh
 *  @brief  (22,16)ハミング符号
 *
 *  @par    Copyright
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/05/01  T. Ishitani     coding start
 */

function [5:0] f_calc_parity_hamming_22_16 (
    input   [15:0]  i_d
);
    f_calc_parity_hamming_22_16 = {
        //  x^15 +   x^14 +   x^13 +   x^12 +   x^11 +   x^10 +   x^9 +   x^8 +   x^7 +   x^6 +   x^5 +   x^4 +   x^3 +   x^2 +   x^1 +   x^0
        ^{                           i_d[12], i_d[11], i_d[10], i_d[9], i_d[8],                 i_d[5], i_d[4],         i_d[2]                },    //  0x1f34
        ^{i_d[15],                            i_d[11], i_d[10], i_d[9], i_d[8], i_d[7],                 i_d[4], i_d[3],         i_d[1]        },    //  0x8f9a
        ^{i_d[15], i_d[14],                            i_d[10], i_d[9], i_d[8], i_d[7], i_d[6],                 i_d[3], i_d[2],         i_d[0]},    //  0xc7cd
        ^{         i_d[14], i_d[13], i_d[12], i_d[11], i_d[10],                 i_d[7], i_d[6],         i_d[4],                 i_d[1]        },    //  0x7cd2
        ^{                  i_d[13], i_d[12], i_d[11], i_d[10], i_d[9],                 i_d[6], i_d[5],         i_d[3],                 i_d[0]},    //  0x3e69
        ^{i_d[15], i_d[14], i_d[13],          i_d[11],          i_d[9],                         i_d[5],                 i_d[2], i_d[1], i_d[0]}     //  0xea27
    };
endfunction

function [21:0] f_decode_syndrome_hamming_22_16 (
    input   [5:0]   i_syn
);
    f_decode_syndrome_hamming_22_16 = {
        ((i_syn == 6'h19) ? 1'b1 : 1'b0),
        ((i_syn == 6'h0d) ? 1'b1 : 1'b0),
        ((i_syn == 6'h07) ? 1'b1 : 1'b0),
        ((i_syn == 6'h26) ? 1'b1 : 1'b0),
        ((i_syn == 6'h37) ? 1'b1 : 1'b0),
        ((i_syn == 6'h3e) ? 1'b1 : 1'b0),
        ((i_syn == 6'h3b) ? 1'b1 : 1'b0),
        ((i_syn == 6'h38) ? 1'b1 : 1'b0),
        ((i_syn == 6'h1c) ? 1'b1 : 1'b0),
        ((i_syn == 6'h0e) ? 1'b1 : 1'b0),
        ((i_syn == 6'h23) ? 1'b1 : 1'b0),
        ((i_syn == 6'h34) ? 1'b1 : 1'b0),
        ((i_syn == 6'h1a) ? 1'b1 : 1'b0),
        ((i_syn == 6'h29) ? 1'b1 : 1'b0),
        ((i_syn == 6'h15) ? 1'b1 : 1'b0),
        ((i_syn == 6'h0b) ? 1'b1 : 1'b0),
        ((i_syn == 6'h20) ? 1'b1 : 1'b0),
        ((i_syn == 6'h10) ? 1'b1 : 1'b0),
        ((i_syn == 6'h08) ? 1'b1 : 1'b0),
        ((i_syn == 6'h04) ? 1'b1 : 1'b0),
        ((i_syn == 6'h02) ? 1'b1 : 1'b0),
        ((i_syn == 6'h01) ? 1'b1 : 1'b0)
    };
endfunction
