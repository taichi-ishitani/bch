/**
 *  @file   hamming_39_32.vh
 *  @brief  (39,32)ハミング符号
 *
 *  @par    Copyright
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/05/01  T. Ishitani     coding start
 */

function [6:0] f_calc_parity_hamming_39_32 (
    input   [31:0]  i_d
);
    f_calc_parity_hamming_39_32 = {
        //  x^31 +   x^30 +   x^29 +   x^28 +   x^27 +   x^26 +   x^25 +   x^24 +   x^23 +   x^22 +   x^21 +   x^20 +   x^19 +   x^18 +   x^17 +   x^16 +   x^15 +   x^14 +   x^13 +   x^12 +   x^11 +   x^10 +   x^9 +   x^8 +   x^7 +   x^6 +   x^5 +   x^4 +   x^3 +   x^2 +   x^1 +   x^0
        ^{i_d[31],                   i_d[28],                   i_d[25], i_d[24], i_d[23],                            i_d[19],          i_d[17], i_d[16], i_d[15], i_d[14],                   i_d[11],          i_d[9],                         i_d[5], i_d[4]                                },    //  0x938bca30
        ^{         i_d[30],                   i_d[27],                   i_d[24], i_d[23], i_d[22],                            i_d[18],          i_d[16], i_d[15], i_d[14], i_d[13],                   i_d[10],         i_d[8],                         i_d[4], i_d[3]                        },    //  0x49c5e518
        ^{i_d[31],          i_d[29],                   i_d[26],                   i_d[23], i_d[22], i_d[21],                            i_d[17],          i_d[15], i_d[14], i_d[13], i_d[12],                   i_d[9],         i_d[7],                         i_d[3], i_d[2]                },    //  0xa4e2f28c
        ^{i_d[31], i_d[30],          i_d[28],                   i_d[25],                   i_d[22], i_d[21], i_d[20],                            i_d[16],          i_d[14], i_d[13], i_d[12], i_d[11],                  i_d[8],         i_d[6],                         i_d[2], i_d[1]        },    //  0xd2717946
        ^{         i_d[30], i_d[29],          i_d[27],                   i_d[24],                   i_d[21], i_d[20], i_d[19],                            i_d[15],          i_d[13], i_d[12], i_d[11], i_d[10],                 i_d[7],         i_d[5],                         i_d[1], i_d[0]},    //  0x6938bca3
        ^{                  i_d[29],                   i_d[26], i_d[25], i_d[24],                            i_d[20],          i_d[18], i_d[17], i_d[16], i_d[15],                   i_d[12],          i_d[10],                         i_d[6], i_d[5],                                 i_d[0]},    //  0x27179461
        ^{                           i_d[28], i_d[27], i_d[26],          i_d[24],                                     i_d[19], i_d[18],          i_d[16],          i_d[14], i_d[13], i_d[12],                   i_d[9], i_d[8], i_d[7], i_d[6],         i_d[4], i_d[3], i_d[2], i_d[1], i_d[0]}     //  0x1d0d73df
    };
endfunction

function [38:0] f_decode_syndrome_hamming_39_32 (
    input   [6:0]   i_syn
);
    f_decode_syndrome_hamming_39_32 = {
        ((i_syn == 7'h58) ? 1'b1 : 1'b0),
        ((i_syn == 7'h2c) ? 1'b1 : 1'b0),
        ((i_syn == 7'h16) ? 1'b1 : 1'b0),
        ((i_syn == 7'h49) ? 1'b1 : 1'b0),
        ((i_syn == 7'h25) ? 1'b1 : 1'b0),
        ((i_syn == 7'h13) ? 1'b1 : 1'b0),
        ((i_syn == 7'h4a) ? 1'b1 : 1'b0),
        ((i_syn == 7'h67) ? 1'b1 : 1'b0),
        ((i_syn == 7'h70) ? 1'b1 : 1'b0),
        ((i_syn == 7'h38) ? 1'b1 : 1'b0),
        ((i_syn == 7'h1c) ? 1'b1 : 1'b0),
        ((i_syn == 7'h0e) ? 1'b1 : 1'b0),
        ((i_syn == 7'h45) ? 1'b1 : 1'b0),
        ((i_syn == 7'h23) ? 1'b1 : 1'b0),
        ((i_syn == 7'h52) ? 1'b1 : 1'b0),
        ((i_syn == 7'h6b) ? 1'b1 : 1'b0),
        ((i_syn == 7'h76) ? 1'b1 : 1'b0),
        ((i_syn == 7'h79) ? 1'b1 : 1'b0),
        ((i_syn == 7'h3d) ? 1'b1 : 1'b0),
        ((i_syn == 7'h1f) ? 1'b1 : 1'b0),
        ((i_syn == 7'h4c) ? 1'b1 : 1'b0),
        ((i_syn == 7'h26) ? 1'b1 : 1'b0),
        ((i_syn == 7'h51) ? 1'b1 : 1'b0),
        ((i_syn == 7'h29) ? 1'b1 : 1'b0),
        ((i_syn == 7'h15) ? 1'b1 : 1'b0),
        ((i_syn == 7'h0b) ? 1'b1 : 1'b0),
        ((i_syn == 7'h46) ? 1'b1 : 1'b0),
        ((i_syn == 7'h61) ? 1'b1 : 1'b0),
        ((i_syn == 7'h31) ? 1'b1 : 1'b0),
        ((i_syn == 7'h19) ? 1'b1 : 1'b0),
        ((i_syn == 7'h0d) ? 1'b1 : 1'b0),
        ((i_syn == 7'h07) ? 1'b1 : 1'b0),
        ((i_syn == 7'h40) ? 1'b1 : 1'b0),
        ((i_syn == 7'h20) ? 1'b1 : 1'b0),
        ((i_syn == 7'h10) ? 1'b1 : 1'b0),
        ((i_syn == 7'h08) ? 1'b1 : 1'b0),
        ((i_syn == 7'h04) ? 1'b1 : 1'b0),
        ((i_syn == 7'h02) ? 1'b1 : 1'b0),
        ((i_syn == 7'h01) ? 1'b1 : 1'b0)
    };
endfunction
