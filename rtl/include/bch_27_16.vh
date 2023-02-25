/**
 *  @file   bch_27_16.vh
 *  @brief  (27,16)BCH符号
 *
 *  @par    Copyright
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/05/01  T. Ishitani     coding start
 */

function [10:0] f_calc_parity_bch_27_16 (
    input   [15:0]  i_d
);
    f_calc_parity_bch_27_16 = {
        //  x^15 +   x^14 +   x^13 +   x^12 +   x^11 +   x^10 +   x^9 +   x^8 +   x^7 +   x^6 +   x^5 +   x^4 +   x^3 +   x^2 +   x^1 +   x^0
        ^{i_d[15],                   i_d[12],                   i_d[9], i_d[8], i_d[7], i_d[6],         i_d[4],         i_d[2],         i_d[0]},    //  0x93d5
        ^{i_d[15], i_d[14],          i_d[12], i_d[11],          i_d[9],                         i_d[5], i_d[4], i_d[3], i_d[2], i_d[1], i_d[0]},    //  0xda3f
        ^{         i_d[14], i_d[13], i_d[12], i_d[11], i_d[10], i_d[9],         i_d[7], i_d[6],                 i_d[3],         i_d[1]        },    //  0x7eca
        ^{i_d[15],          i_d[13], i_d[12], i_d[11], i_d[10], i_d[9], i_d[8],         i_d[6], i_d[5],                 i_d[2],         i_d[0]},    //  0xbf65
        ^{         i_d[14],                   i_d[11], i_d[10],                         i_d[6], i_d[5],                 i_d[2], i_d[1], i_d[0]},    //  0x4c67
        ^{                  i_d[13], i_d[12],          i_d[10],         i_d[8], i_d[7], i_d[6], i_d[5],                 i_d[2], i_d[1]        },    //  0x35e6
        ^{                           i_d[12], i_d[11],          i_d[9],         i_d[7], i_d[6], i_d[5], i_d[4],                 i_d[1], i_d[0]},    //  0x1af3
        ^{i_d[15],                   i_d[12], i_d[11], i_d[10], i_d[9],         i_d[7],         i_d[5],         i_d[3], i_d[2]                },    //  0x9eac
        ^{         i_d[14],                   i_d[11], i_d[10], i_d[9], i_d[8],         i_d[6],         i_d[4],         i_d[2], i_d[1]        },    //  0x4f56
        ^{                  i_d[13],                   i_d[10], i_d[9], i_d[8], i_d[7],         i_d[5],         i_d[3],         i_d[1], i_d[0]},    //  0x27ab
        ^{i_d[15], i_d[14], i_d[13],                            i_d[9],         i_d[7],                 i_d[4], i_d[3],                 i_d[0]}     //  0xe299
    };
endfunction

function [377:0] f_decode_syndrome_bch_27_16 (
    input   [10:0]  i_syn
);
    f_decode_syndrome_bch_27_16 = {
        ((i_syn == 11'h5cc) ? 1'b1 : 1'b0),
        ((i_syn == 11'h72a) ? 1'b1 : 1'b0),
        ((i_syn == 11'h131) ? 1'b1 : 1'b0),
        ((i_syn == 11'h555) ? 1'b1 : 1'b0),
        ((i_syn == 11'h767) ? 1'b1 : 1'b0),
        ((i_syn == 11'h116) ? 1'b1 : 1'b0),
        ((i_syn == 11'h22f) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3b2) ? 1'b1 : 1'b0),
        ((i_syn == 11'h37d) ? 1'b1 : 1'b0),
        ((i_syn == 11'h473) ? 1'b1 : 1'b0),
        ((i_syn == 11'h09c) ? 1'b1 : 1'b0),
        ((i_syn == 11'h582) ? 1'b1 : 1'b0),
        ((i_syn == 11'h065) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5ff) ? 1'b1 : 1'b0),
        ((i_syn == 11'h05a) ? 1'b1 : 1'b0),
        ((i_syn == 11'h289) ? 1'b1 : 1'b0),
        ((i_syn == 11'h489) ? 1'b1 : 1'b0),
        ((i_syn == 11'h789) ? 1'b1 : 1'b0),
        ((i_syn == 11'h609) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6c9) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6a9) ? 1'b1 : 1'b0),
        ((i_syn == 11'h699) ? 1'b1 : 1'b0),
        ((i_syn == 11'h681) ? 1'b1 : 1'b0),
        ((i_syn == 11'h68d) ? 1'b1 : 1'b0),
        ((i_syn == 11'h68b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h688) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2e6) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4fd) ? 1'b1 : 1'b0),
        ((i_syn == 11'h099) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2ab) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4da) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7e3) ? 1'b1 : 1'b0),
        ((i_syn == 11'h67e) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6b1) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1bf) ? 1'b1 : 1'b0),
        ((i_syn == 11'h550) ? 1'b1 : 1'b0),
        ((i_syn == 11'h04e) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5a9) ? 1'b1 : 1'b0),
        ((i_syn == 11'h033) ? 1'b1 : 1'b0),
        ((i_syn == 11'h596) ? 1'b1 : 1'b0),
        ((i_syn == 11'h745) ? 1'b1 : 1'b0),
        ((i_syn == 11'h145) ? 1'b1 : 1'b0),
        ((i_syn == 11'h245) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3c5) ? 1'b1 : 1'b0),
        ((i_syn == 11'h305) ? 1'b1 : 1'b0),
        ((i_syn == 11'h365) ? 1'b1 : 1'b0),
        ((i_syn == 11'h355) ? 1'b1 : 1'b0),
        ((i_syn == 11'h34d) ? 1'b1 : 1'b0),
        ((i_syn == 11'h341) ? 1'b1 : 1'b0),
        ((i_syn == 11'h347) ? 1'b1 : 1'b0),
        ((i_syn == 11'h344) ? 1'b1 : 1'b0),
        ((i_syn == 11'h61b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h27f) ? 1'b1 : 1'b0),
        ((i_syn == 11'h04d) ? 1'b1 : 1'b0),
        ((i_syn == 11'h63c) ? 1'b1 : 1'b0),
        ((i_syn == 11'h505) ? 1'b1 : 1'b0),
        ((i_syn == 11'h498) ? 1'b1 : 1'b0),
        ((i_syn == 11'h457) ? 1'b1 : 1'b0),
        ((i_syn == 11'h359) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7b6) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2a8) ? 1'b1 : 1'b0),
        ((i_syn == 11'h74f) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2d5) ? 1'b1 : 1'b0),
        ((i_syn == 11'h770) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5a3) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3a3) ? 1'b1 : 1'b0),
        ((i_syn == 11'h0a3) ? 1'b1 : 1'b0),
        ((i_syn == 11'h123) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1e3) ? 1'b1 : 1'b0),
        ((i_syn == 11'h183) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1b3) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1ab) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1a7) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1a1) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1a2) ? 1'b1 : 1'b0),
        ((i_syn == 11'h464) ? 1'b1 : 1'b0),
        ((i_syn == 11'h656) ? 1'b1 : 1'b0),
        ((i_syn == 11'h027) ? 1'b1 : 1'b0),
        ((i_syn == 11'h31e) ? 1'b1 : 1'b0),
        ((i_syn == 11'h283) ? 1'b1 : 1'b0),
        ((i_syn == 11'h24c) ? 1'b1 : 1'b0),
        ((i_syn == 11'h542) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1ad) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4b3) ? 1'b1 : 1'b0),
        ((i_syn == 11'h154) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4ce) ? 1'b1 : 1'b0),
        ((i_syn == 11'h16b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3b8) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5b8) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6b8) ? 1'b1 : 1'b0),
        ((i_syn == 11'h738) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7f8) ? 1'b1 : 1'b0),
        ((i_syn == 11'h798) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7a8) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7b0) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7bc) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7ba) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7b9) ? 1'b1 : 1'b0),
        ((i_syn == 11'h232) ? 1'b1 : 1'b0),
        ((i_syn == 11'h443) ? 1'b1 : 1'b0),
        ((i_syn == 11'h77a) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6e7) ? 1'b1 : 1'b0),
        ((i_syn == 11'h628) ? 1'b1 : 1'b0),
        ((i_syn == 11'h126) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5c9) ? 1'b1 : 1'b0),
        ((i_syn == 11'h0d7) ? 1'b1 : 1'b0),
        ((i_syn == 11'h530) ? 1'b1 : 1'b0),
        ((i_syn == 11'h0aa) ? 1'b1 : 1'b0),
        ((i_syn == 11'h50f) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7dc) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1dc) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2dc) ? 1'b1 : 1'b0),
        ((i_syn == 11'h35c) ? 1'b1 : 1'b0),
        ((i_syn == 11'h39c) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3fc) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3cc) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3d4) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3d8) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3de) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3dd) ? 1'b1 : 1'b0),
        ((i_syn == 11'h671) ? 1'b1 : 1'b0),
        ((i_syn == 11'h548) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4d5) ? 1'b1 : 1'b0),
        ((i_syn == 11'h41a) ? 1'b1 : 1'b0),
        ((i_syn == 11'h314) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7fb) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2e5) ? 1'b1 : 1'b0),
        ((i_syn == 11'h702) ? 1'b1 : 1'b0),
        ((i_syn == 11'h298) ? 1'b1 : 1'b0),
        ((i_syn == 11'h73d) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5ee) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3ee) ? 1'b1 : 1'b0),
        ((i_syn == 11'h0ee) ? 1'b1 : 1'b0),
        ((i_syn == 11'h16e) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1ae) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1ce) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1fe) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1e6) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1ea) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1ec) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1ef) ? 1'b1 : 1'b0),
        ((i_syn == 11'h339) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2a4) ? 1'b1 : 1'b0),
        ((i_syn == 11'h26b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h565) ? 1'b1 : 1'b0),
        ((i_syn == 11'h18a) ? 1'b1 : 1'b0),
        ((i_syn == 11'h494) ? 1'b1 : 1'b0),
        ((i_syn == 11'h173) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4e9) ? 1'b1 : 1'b0),
        ((i_syn == 11'h14c) ? 1'b1 : 1'b0),
        ((i_syn == 11'h39f) ? 1'b1 : 1'b0),
        ((i_syn == 11'h59f) ? 1'b1 : 1'b0),
        ((i_syn == 11'h69f) ? 1'b1 : 1'b0),
        ((i_syn == 11'h71f) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7df) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7bf) ? 1'b1 : 1'b0),
        ((i_syn == 11'h78f) ? 1'b1 : 1'b0),
        ((i_syn == 11'h797) ? 1'b1 : 1'b0),
        ((i_syn == 11'h79b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h79d) ? 1'b1 : 1'b0),
        ((i_syn == 11'h79e) ? 1'b1 : 1'b0),
        ((i_syn == 11'h19d) ? 1'b1 : 1'b0),
        ((i_syn == 11'h152) ? 1'b1 : 1'b0),
        ((i_syn == 11'h65c) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2b3) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7ad) ? 1'b1 : 1'b0),
        ((i_syn == 11'h24a) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7d0) ? 1'b1 : 1'b0),
        ((i_syn == 11'h275) ? 1'b1 : 1'b0),
        ((i_syn == 11'h0a6) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6a6) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5a6) ? 1'b1 : 1'b0),
        ((i_syn == 11'h426) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4e6) ? 1'b1 : 1'b0),
        ((i_syn == 11'h486) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4b6) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4ae) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4a2) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4a4) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4a7) ? 1'b1 : 1'b0),
        ((i_syn == 11'h0cf) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7c1) ? 1'b1 : 1'b0),
        ((i_syn == 11'h32e) ? 1'b1 : 1'b0),
        ((i_syn == 11'h630) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3d7) ? 1'b1 : 1'b0),
        ((i_syn == 11'h64d) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3e8) ? 1'b1 : 1'b0),
        ((i_syn == 11'h13b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h73b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h43b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5bb) ? 1'b1 : 1'b0),
        ((i_syn == 11'h57b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h51b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h52b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h533) ? 1'b1 : 1'b0),
        ((i_syn == 11'h53f) ? 1'b1 : 1'b0),
        ((i_syn == 11'h539) ? 1'b1 : 1'b0),
        ((i_syn == 11'h53a) ? 1'b1 : 1'b0),
        ((i_syn == 11'h70e) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3e1) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6ff) ? 1'b1 : 1'b0),
        ((i_syn == 11'h318) ? 1'b1 : 1'b0),
        ((i_syn == 11'h682) ? 1'b1 : 1'b0),
        ((i_syn == 11'h327) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1f4) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7f4) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4f4) ? 1'b1 : 1'b0),
        ((i_syn == 11'h574) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5b4) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5d4) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5e4) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5fc) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5f0) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5f6) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5f5) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4ef) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1f1) ? 1'b1 : 1'b0),
        ((i_syn == 11'h416) ? 1'b1 : 1'b0),
        ((i_syn == 11'h18c) ? 1'b1 : 1'b0),
        ((i_syn == 11'h429) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6fa) ? 1'b1 : 1'b0),
        ((i_syn == 11'h0fa) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3fa) ? 1'b1 : 1'b0),
        ((i_syn == 11'h27a) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2ba) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2da) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2ea) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2f2) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2fe) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2f8) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2fb) ? 1'b1 : 1'b0),
        ((i_syn == 11'h51e) ? 1'b1 : 1'b0),
        ((i_syn == 11'h0f9) ? 1'b1 : 1'b0),
        ((i_syn == 11'h563) ? 1'b1 : 1'b0),
        ((i_syn == 11'h0c6) ? 1'b1 : 1'b0),
        ((i_syn == 11'h215) ? 1'b1 : 1'b0),
        ((i_syn == 11'h415) ? 1'b1 : 1'b0),
        ((i_syn == 11'h715) ? 1'b1 : 1'b0),
        ((i_syn == 11'h695) ? 1'b1 : 1'b0),
        ((i_syn == 11'h655) ? 1'b1 : 1'b0),
        ((i_syn == 11'h635) ? 1'b1 : 1'b0),
        ((i_syn == 11'h605) ? 1'b1 : 1'b0),
        ((i_syn == 11'h61d) ? 1'b1 : 1'b0),
        ((i_syn == 11'h611) ? 1'b1 : 1'b0),
        ((i_syn == 11'h617) ? 1'b1 : 1'b0),
        ((i_syn == 11'h614) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5e7) ? 1'b1 : 1'b0),
        ((i_syn == 11'h07d) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5d8) ? 1'b1 : 1'b0),
        ((i_syn == 11'h70b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h10b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h20b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h38b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h34b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h32b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h31b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h303) ? 1'b1 : 1'b0),
        ((i_syn == 11'h30f) ? 1'b1 : 1'b0),
        ((i_syn == 11'h309) ? 1'b1 : 1'b0),
        ((i_syn == 11'h30a) ? 1'b1 : 1'b0),
        ((i_syn == 11'h59a) ? 1'b1 : 1'b0),
        ((i_syn == 11'h03f) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2ec) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4ec) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7ec) ? 1'b1 : 1'b0),
        ((i_syn == 11'h66c) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6ac) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6cc) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6fc) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6e4) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6e8) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6ee) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6ed) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5a5) ? 1'b1 : 1'b0),
        ((i_syn == 11'h776) ? 1'b1 : 1'b0),
        ((i_syn == 11'h176) ? 1'b1 : 1'b0),
        ((i_syn == 11'h276) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3f6) ? 1'b1 : 1'b0),
        ((i_syn == 11'h336) ? 1'b1 : 1'b0),
        ((i_syn == 11'h356) ? 1'b1 : 1'b0),
        ((i_syn == 11'h366) ? 1'b1 : 1'b0),
        ((i_syn == 11'h37e) ? 1'b1 : 1'b0),
        ((i_syn == 11'h372) ? 1'b1 : 1'b0),
        ((i_syn == 11'h374) ? 1'b1 : 1'b0),
        ((i_syn == 11'h377) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2d3) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4d3) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7d3) ? 1'b1 : 1'b0),
        ((i_syn == 11'h653) ? 1'b1 : 1'b0),
        ((i_syn == 11'h693) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6f3) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6c3) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6db) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6d7) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6d1) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6d2) ? 1'b1 : 1'b0),
        ((i_syn == 11'h689) ? 1'b1 : 1'b0),
        ((i_syn == 11'h345) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1a3) ? 1'b1 : 1'b0),
        ((i_syn == 11'h7b8) ? 1'b1 : 1'b0),
        ((i_syn == 11'h3dc) ? 1'b1 : 1'b0),
        ((i_syn == 11'h1ee) ? 1'b1 : 1'b0),
        ((i_syn == 11'h79f) ? 1'b1 : 1'b0),
        ((i_syn == 11'h4a6) ? 1'b1 : 1'b0),
        ((i_syn == 11'h53b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h5f4) ? 1'b1 : 1'b0),
        ((i_syn == 11'h2fa) ? 1'b1 : 1'b0),
        ((i_syn == 11'h615) ? 1'b1 : 1'b0),
        ((i_syn == 11'h30b) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6ec) ? 1'b1 : 1'b0),
        ((i_syn == 11'h376) ? 1'b1 : 1'b0),
        ((i_syn == 11'h6d3) ? 1'b1 : 1'b0),
        ((i_syn == 11'h600) ? 1'b1 : 1'b0),
        ((i_syn == 11'h500) ? 1'b1 : 1'b0),
        ((i_syn == 11'h480) ? 1'b1 : 1'b0),
        ((i_syn == 11'h440) ? 1'b1 : 1'b0),
        ((i_syn == 11'h420) ? 1'b1 : 1'b0),
        ((i_syn == 11'h410) ? 1'b1 : 1'b0),
        ((i_syn == 11'h408) ? 1'b1 : 1'b0),
        ((i_syn == 11'h404) ? 1'b1 : 1'b0),
        ((i_syn == 11'h402) ? 1'b1 : 1'b0),
        ((i_syn == 11'h401) ? 1'b1 : 1'b0),
        ((i_syn == 11'h300) ? 1'b1 : 1'b0),
        ((i_syn == 11'h280) ? 1'b1 : 1'b0),
        ((i_syn == 11'h240) ? 1'b1 : 1'b0),
        ((i_syn == 11'h220) ? 1'b1 : 1'b0),
        ((i_syn == 11'h210) ? 1'b1 : 1'b0),
        ((i_syn == 11'h208) ? 1'b1 : 1'b0),
        ((i_syn == 11'h204) ? 1'b1 : 1'b0),
        ((i_syn == 11'h202) ? 1'b1 : 1'b0),
        ((i_syn == 11'h201) ? 1'b1 : 1'b0),
        ((i_syn == 11'h180) ? 1'b1 : 1'b0),
        ((i_syn == 11'h140) ? 1'b1 : 1'b0),
        ((i_syn == 11'h120) ? 1'b1 : 1'b0),
        ((i_syn == 11'h110) ? 1'b1 : 1'b0),
        ((i_syn == 11'h108) ? 1'b1 : 1'b0),
        ((i_syn == 11'h104) ? 1'b1 : 1'b0),
        ((i_syn == 11'h102) ? 1'b1 : 1'b0),
        ((i_syn == 11'h101) ? 1'b1 : 1'b0),
        ((i_syn == 11'h0c0) ? 1'b1 : 1'b0),
        ((i_syn == 11'h0a0) ? 1'b1 : 1'b0),
        ((i_syn == 11'h090) ? 1'b1 : 1'b0),
        ((i_syn == 11'h088) ? 1'b1 : 1'b0),
        ((i_syn == 11'h084) ? 1'b1 : 1'b0),
        ((i_syn == 11'h082) ? 1'b1 : 1'b0),
        ((i_syn == 11'h081) ? 1'b1 : 1'b0),
        ((i_syn == 11'h060) ? 1'b1 : 1'b0),
        ((i_syn == 11'h050) ? 1'b1 : 1'b0),
        ((i_syn == 11'h048) ? 1'b1 : 1'b0),
        ((i_syn == 11'h044) ? 1'b1 : 1'b0),
        ((i_syn == 11'h042) ? 1'b1 : 1'b0),
        ((i_syn == 11'h041) ? 1'b1 : 1'b0),
        ((i_syn == 11'h030) ? 1'b1 : 1'b0),
        ((i_syn == 11'h028) ? 1'b1 : 1'b0),
        ((i_syn == 11'h024) ? 1'b1 : 1'b0),
        ((i_syn == 11'h022) ? 1'b1 : 1'b0),
        ((i_syn == 11'h021) ? 1'b1 : 1'b0),
        ((i_syn == 11'h018) ? 1'b1 : 1'b0),
        ((i_syn == 11'h014) ? 1'b1 : 1'b0),
        ((i_syn == 11'h012) ? 1'b1 : 1'b0),
        ((i_syn == 11'h011) ? 1'b1 : 1'b0),
        ((i_syn == 11'h00c) ? 1'b1 : 1'b0),
        ((i_syn == 11'h00a) ? 1'b1 : 1'b0),
        ((i_syn == 11'h009) ? 1'b1 : 1'b0),
        ((i_syn == 11'h006) ? 1'b1 : 1'b0),
        ((i_syn == 11'h005) ? 1'b1 : 1'b0),
        ((i_syn == 11'h003) ? 1'b1 : 1'b0),
        ((i_syn == 11'h400) ? 1'b1 : 1'b0),
        ((i_syn == 11'h200) ? 1'b1 : 1'b0),
        ((i_syn == 11'h100) ? 1'b1 : 1'b0),
        ((i_syn == 11'h080) ? 1'b1 : 1'b0),
        ((i_syn == 11'h040) ? 1'b1 : 1'b0),
        ((i_syn == 11'h020) ? 1'b1 : 1'b0),
        ((i_syn == 11'h010) ? 1'b1 : 1'b0),
        ((i_syn == 11'h008) ? 1'b1 : 1'b0),
        ((i_syn == 11'h004) ? 1'b1 : 1'b0),
        ((i_syn == 11'h002) ? 1'b1 : 1'b0),
        ((i_syn == 11'h001) ? 1'b1 : 1'b0)
    };
endfunction

function [15:0] f_select_pattern_bch_27_16 (
    input   [311:0] i_sel
);
    f_select_pattern_bch_27_16  = ({16{i_sel[311]}} & 16'hc000)     //  syndrome : 0x5cc
                                | ({16{i_sel[310]}} & 16'ha000)     //  syndrome : 0x72a
                                | ({16{i_sel[309]}} & 16'h9000)     //  syndrome : 0x131
                                | ({16{i_sel[308]}} & 16'h8800)     //  syndrome : 0x555
                                | ({16{i_sel[307]}} & 16'h8400)     //  syndrome : 0x767
                                | ({16{i_sel[306]}} & 16'h8200)     //  syndrome : 0x116
                                | ({16{i_sel[305]}} & 16'h8100)     //  syndrome : 0x22f
                                | ({16{i_sel[304]}} & 16'h8080)     //  syndrome : 0x3b2
                                | ({16{i_sel[303]}} & 16'h8040)     //  syndrome : 0x37d
                                | ({16{i_sel[302]}} & 16'h8020)     //  syndrome : 0x473
                                | ({16{i_sel[301]}} & 16'h8010)     //  syndrome : 0x09c
                                | ({16{i_sel[300]}} & 16'h8008)     //  syndrome : 0x582
                                | ({16{i_sel[299]}} & 16'h8004)     //  syndrome : 0x065
                                | ({16{i_sel[298]}} & 16'h8002)     //  syndrome : 0x5ff
                                | ({16{i_sel[297]}} & 16'h8001)     //  syndrome : 0x05a
                                | ({16{i_sel[296]}} & 16'h8000)     //  syndrome : 0x289
                                | ({16{i_sel[295]}} & 16'h8000)     //  syndrome : 0x489
                                | ({16{i_sel[294]}} & 16'h8000)     //  syndrome : 0x789
                                | ({16{i_sel[293]}} & 16'h8000)     //  syndrome : 0x609
                                | ({16{i_sel[292]}} & 16'h8000)     //  syndrome : 0x6c9
                                | ({16{i_sel[291]}} & 16'h8000)     //  syndrome : 0x6a9
                                | ({16{i_sel[290]}} & 16'h8000)     //  syndrome : 0x699
                                | ({16{i_sel[289]}} & 16'h8000)     //  syndrome : 0x681
                                | ({16{i_sel[288]}} & 16'h8000)     //  syndrome : 0x68d
                                | ({16{i_sel[287]}} & 16'h8000)     //  syndrome : 0x68b
                                | ({16{i_sel[286]}} & 16'h8000)     //  syndrome : 0x688
                                | ({16{i_sel[285]}} & 16'h6000)     //  syndrome : 0x2e6
                                | ({16{i_sel[284]}} & 16'h5000)     //  syndrome : 0x4fd
                                | ({16{i_sel[283]}} & 16'h4800)     //  syndrome : 0x099
                                | ({16{i_sel[282]}} & 16'h4400)     //  syndrome : 0x2ab
                                | ({16{i_sel[281]}} & 16'h4200)     //  syndrome : 0x4da
                                | ({16{i_sel[280]}} & 16'h4100)     //  syndrome : 0x7e3
                                | ({16{i_sel[279]}} & 16'h4080)     //  syndrome : 0x67e
                                | ({16{i_sel[278]}} & 16'h4040)     //  syndrome : 0x6b1
                                | ({16{i_sel[277]}} & 16'h4020)     //  syndrome : 0x1bf
                                | ({16{i_sel[276]}} & 16'h4010)     //  syndrome : 0x550
                                | ({16{i_sel[275]}} & 16'h4008)     //  syndrome : 0x04e
                                | ({16{i_sel[274]}} & 16'h4004)     //  syndrome : 0x5a9
                                | ({16{i_sel[273]}} & 16'h4002)     //  syndrome : 0x033
                                | ({16{i_sel[272]}} & 16'h4001)     //  syndrome : 0x596
                                | ({16{i_sel[271]}} & 16'h4000)     //  syndrome : 0x745
                                | ({16{i_sel[270]}} & 16'h4000)     //  syndrome : 0x145
                                | ({16{i_sel[269]}} & 16'h4000)     //  syndrome : 0x245
                                | ({16{i_sel[268]}} & 16'h4000)     //  syndrome : 0x3c5
                                | ({16{i_sel[267]}} & 16'h4000)     //  syndrome : 0x305
                                | ({16{i_sel[266]}} & 16'h4000)     //  syndrome : 0x365
                                | ({16{i_sel[265]}} & 16'h4000)     //  syndrome : 0x355
                                | ({16{i_sel[264]}} & 16'h4000)     //  syndrome : 0x34d
                                | ({16{i_sel[263]}} & 16'h4000)     //  syndrome : 0x341
                                | ({16{i_sel[262]}} & 16'h4000)     //  syndrome : 0x347
                                | ({16{i_sel[261]}} & 16'h4000)     //  syndrome : 0x344
                                | ({16{i_sel[260]}} & 16'h3000)     //  syndrome : 0x61b
                                | ({16{i_sel[259]}} & 16'h2800)     //  syndrome : 0x27f
                                | ({16{i_sel[258]}} & 16'h2400)     //  syndrome : 0x04d
                                | ({16{i_sel[257]}} & 16'h2200)     //  syndrome : 0x63c
                                | ({16{i_sel[256]}} & 16'h2100)     //  syndrome : 0x505
                                | ({16{i_sel[255]}} & 16'h2080)     //  syndrome : 0x498
                                | ({16{i_sel[254]}} & 16'h2040)     //  syndrome : 0x457
                                | ({16{i_sel[253]}} & 16'h2020)     //  syndrome : 0x359
                                | ({16{i_sel[252]}} & 16'h2010)     //  syndrome : 0x7b6
                                | ({16{i_sel[251]}} & 16'h2008)     //  syndrome : 0x2a8
                                | ({16{i_sel[250]}} & 16'h2004)     //  syndrome : 0x74f
                                | ({16{i_sel[249]}} & 16'h2002)     //  syndrome : 0x2d5
                                | ({16{i_sel[248]}} & 16'h2001)     //  syndrome : 0x770
                                | ({16{i_sel[247]}} & 16'h2000)     //  syndrome : 0x5a3
                                | ({16{i_sel[246]}} & 16'h2000)     //  syndrome : 0x3a3
                                | ({16{i_sel[245]}} & 16'h2000)     //  syndrome : 0x0a3
                                | ({16{i_sel[244]}} & 16'h2000)     //  syndrome : 0x123
                                | ({16{i_sel[243]}} & 16'h2000)     //  syndrome : 0x1e3
                                | ({16{i_sel[242]}} & 16'h2000)     //  syndrome : 0x183
                                | ({16{i_sel[241]}} & 16'h2000)     //  syndrome : 0x1b3
                                | ({16{i_sel[240]}} & 16'h2000)     //  syndrome : 0x1ab
                                | ({16{i_sel[239]}} & 16'h2000)     //  syndrome : 0x1a7
                                | ({16{i_sel[238]}} & 16'h2000)     //  syndrome : 0x1a1
                                | ({16{i_sel[237]}} & 16'h2000)     //  syndrome : 0x1a2
                                | ({16{i_sel[236]}} & 16'h1800)     //  syndrome : 0x464
                                | ({16{i_sel[235]}} & 16'h1400)     //  syndrome : 0x656
                                | ({16{i_sel[234]}} & 16'h1200)     //  syndrome : 0x027
                                | ({16{i_sel[233]}} & 16'h1100)     //  syndrome : 0x31e
                                | ({16{i_sel[232]}} & 16'h1080)     //  syndrome : 0x283
                                | ({16{i_sel[231]}} & 16'h1040)     //  syndrome : 0x24c
                                | ({16{i_sel[230]}} & 16'h1020)     //  syndrome : 0x542
                                | ({16{i_sel[229]}} & 16'h1010)     //  syndrome : 0x1ad
                                | ({16{i_sel[228]}} & 16'h1008)     //  syndrome : 0x4b3
                                | ({16{i_sel[227]}} & 16'h1004)     //  syndrome : 0x154
                                | ({16{i_sel[226]}} & 16'h1002)     //  syndrome : 0x4ce
                                | ({16{i_sel[225]}} & 16'h1001)     //  syndrome : 0x16b
                                | ({16{i_sel[224]}} & 16'h1000)     //  syndrome : 0x3b8
                                | ({16{i_sel[223]}} & 16'h1000)     //  syndrome : 0x5b8
                                | ({16{i_sel[222]}} & 16'h1000)     //  syndrome : 0x6b8
                                | ({16{i_sel[221]}} & 16'h1000)     //  syndrome : 0x738
                                | ({16{i_sel[220]}} & 16'h1000)     //  syndrome : 0x7f8
                                | ({16{i_sel[219]}} & 16'h1000)     //  syndrome : 0x798
                                | ({16{i_sel[218]}} & 16'h1000)     //  syndrome : 0x7a8
                                | ({16{i_sel[217]}} & 16'h1000)     //  syndrome : 0x7b0
                                | ({16{i_sel[216]}} & 16'h1000)     //  syndrome : 0x7bc
                                | ({16{i_sel[215]}} & 16'h1000)     //  syndrome : 0x7ba
                                | ({16{i_sel[214]}} & 16'h1000)     //  syndrome : 0x7b9
                                | ({16{i_sel[213]}} & 16'h0c00)     //  syndrome : 0x232
                                | ({16{i_sel[212]}} & 16'h0a00)     //  syndrome : 0x443
                                | ({16{i_sel[211]}} & 16'h0900)     //  syndrome : 0x77a
                                | ({16{i_sel[210]}} & 16'h0880)     //  syndrome : 0x6e7
                                | ({16{i_sel[209]}} & 16'h0840)     //  syndrome : 0x628
                                | ({16{i_sel[208]}} & 16'h0820)     //  syndrome : 0x126
                                | ({16{i_sel[207]}} & 16'h0810)     //  syndrome : 0x5c9
                                | ({16{i_sel[206]}} & 16'h0808)     //  syndrome : 0x0d7
                                | ({16{i_sel[205]}} & 16'h0804)     //  syndrome : 0x530
                                | ({16{i_sel[204]}} & 16'h0802)     //  syndrome : 0x0aa
                                | ({16{i_sel[203]}} & 16'h0801)     //  syndrome : 0x50f
                                | ({16{i_sel[202]}} & 16'h0800)     //  syndrome : 0x7dc
                                | ({16{i_sel[201]}} & 16'h0800)     //  syndrome : 0x1dc
                                | ({16{i_sel[200]}} & 16'h0800)     //  syndrome : 0x2dc
                                | ({16{i_sel[199]}} & 16'h0800)     //  syndrome : 0x35c
                                | ({16{i_sel[198]}} & 16'h0800)     //  syndrome : 0x39c
                                | ({16{i_sel[197]}} & 16'h0800)     //  syndrome : 0x3fc
                                | ({16{i_sel[196]}} & 16'h0800)     //  syndrome : 0x3cc
                                | ({16{i_sel[195]}} & 16'h0800)     //  syndrome : 0x3d4
                                | ({16{i_sel[194]}} & 16'h0800)     //  syndrome : 0x3d8
                                | ({16{i_sel[193]}} & 16'h0800)     //  syndrome : 0x3de
                                | ({16{i_sel[192]}} & 16'h0800)     //  syndrome : 0x3dd
                                | ({16{i_sel[191]}} & 16'h0600)     //  syndrome : 0x671
                                | ({16{i_sel[190]}} & 16'h0500)     //  syndrome : 0x548
                                | ({16{i_sel[189]}} & 16'h0480)     //  syndrome : 0x4d5
                                | ({16{i_sel[188]}} & 16'h0440)     //  syndrome : 0x41a
                                | ({16{i_sel[187]}} & 16'h0420)     //  syndrome : 0x314
                                | ({16{i_sel[186]}} & 16'h0410)     //  syndrome : 0x7fb
                                | ({16{i_sel[185]}} & 16'h0408)     //  syndrome : 0x2e5
                                | ({16{i_sel[184]}} & 16'h0404)     //  syndrome : 0x702
                                | ({16{i_sel[183]}} & 16'h0402)     //  syndrome : 0x298
                                | ({16{i_sel[182]}} & 16'h0401)     //  syndrome : 0x73d
                                | ({16{i_sel[181]}} & 16'h0400)     //  syndrome : 0x5ee
                                | ({16{i_sel[180]}} & 16'h0400)     //  syndrome : 0x3ee
                                | ({16{i_sel[179]}} & 16'h0400)     //  syndrome : 0x0ee
                                | ({16{i_sel[178]}} & 16'h0400)     //  syndrome : 0x16e
                                | ({16{i_sel[177]}} & 16'h0400)     //  syndrome : 0x1ae
                                | ({16{i_sel[176]}} & 16'h0400)     //  syndrome : 0x1ce
                                | ({16{i_sel[175]}} & 16'h0400)     //  syndrome : 0x1fe
                                | ({16{i_sel[174]}} & 16'h0400)     //  syndrome : 0x1e6
                                | ({16{i_sel[173]}} & 16'h0400)     //  syndrome : 0x1ea
                                | ({16{i_sel[172]}} & 16'h0400)     //  syndrome : 0x1ec
                                | ({16{i_sel[171]}} & 16'h0400)     //  syndrome : 0x1ef
                                | ({16{i_sel[170]}} & 16'h0300)     //  syndrome : 0x339
                                | ({16{i_sel[169]}} & 16'h0280)     //  syndrome : 0x2a4
                                | ({16{i_sel[168]}} & 16'h0240)     //  syndrome : 0x26b
                                | ({16{i_sel[167]}} & 16'h0220)     //  syndrome : 0x565
                                | ({16{i_sel[166]}} & 16'h0210)     //  syndrome : 0x18a
                                | ({16{i_sel[165]}} & 16'h0208)     //  syndrome : 0x494
                                | ({16{i_sel[164]}} & 16'h0204)     //  syndrome : 0x173
                                | ({16{i_sel[163]}} & 16'h0202)     //  syndrome : 0x4e9
                                | ({16{i_sel[162]}} & 16'h0201)     //  syndrome : 0x14c
                                | ({16{i_sel[161]}} & 16'h0200)     //  syndrome : 0x39f
                                | ({16{i_sel[160]}} & 16'h0200)     //  syndrome : 0x59f
                                | ({16{i_sel[159]}} & 16'h0200)     //  syndrome : 0x69f
                                | ({16{i_sel[158]}} & 16'h0200)     //  syndrome : 0x71f
                                | ({16{i_sel[157]}} & 16'h0200)     //  syndrome : 0x7df
                                | ({16{i_sel[156]}} & 16'h0200)     //  syndrome : 0x7bf
                                | ({16{i_sel[155]}} & 16'h0200)     //  syndrome : 0x78f
                                | ({16{i_sel[154]}} & 16'h0200)     //  syndrome : 0x797
                                | ({16{i_sel[153]}} & 16'h0200)     //  syndrome : 0x79b
                                | ({16{i_sel[152]}} & 16'h0200)     //  syndrome : 0x79d
                                | ({16{i_sel[151]}} & 16'h0200)     //  syndrome : 0x79e
                                | ({16{i_sel[150]}} & 16'h0180)     //  syndrome : 0x19d
                                | ({16{i_sel[149]}} & 16'h0140)     //  syndrome : 0x152
                                | ({16{i_sel[148]}} & 16'h0120)     //  syndrome : 0x65c
                                | ({16{i_sel[147]}} & 16'h0110)     //  syndrome : 0x2b3
                                | ({16{i_sel[146]}} & 16'h0108)     //  syndrome : 0x7ad
                                | ({16{i_sel[145]}} & 16'h0104)     //  syndrome : 0x24a
                                | ({16{i_sel[144]}} & 16'h0102)     //  syndrome : 0x7d0
                                | ({16{i_sel[143]}} & 16'h0101)     //  syndrome : 0x275
                                | ({16{i_sel[142]}} & 16'h0100)     //  syndrome : 0x0a6
                                | ({16{i_sel[141]}} & 16'h0100)     //  syndrome : 0x6a6
                                | ({16{i_sel[140]}} & 16'h0100)     //  syndrome : 0x5a6
                                | ({16{i_sel[139]}} & 16'h0100)     //  syndrome : 0x426
                                | ({16{i_sel[138]}} & 16'h0100)     //  syndrome : 0x4e6
                                | ({16{i_sel[137]}} & 16'h0100)     //  syndrome : 0x486
                                | ({16{i_sel[136]}} & 16'h0100)     //  syndrome : 0x4b6
                                | ({16{i_sel[135]}} & 16'h0100)     //  syndrome : 0x4ae
                                | ({16{i_sel[134]}} & 16'h0100)     //  syndrome : 0x4a2
                                | ({16{i_sel[133]}} & 16'h0100)     //  syndrome : 0x4a4
                                | ({16{i_sel[132]}} & 16'h0100)     //  syndrome : 0x4a7
                                | ({16{i_sel[131]}} & 16'h00c0)     //  syndrome : 0x0cf
                                | ({16{i_sel[130]}} & 16'h00a0)     //  syndrome : 0x7c1
                                | ({16{i_sel[129]}} & 16'h0090)     //  syndrome : 0x32e
                                | ({16{i_sel[128]}} & 16'h0088)     //  syndrome : 0x630
                                | ({16{i_sel[127]}} & 16'h0084)     //  syndrome : 0x3d7
                                | ({16{i_sel[126]}} & 16'h0082)     //  syndrome : 0x64d
                                | ({16{i_sel[125]}} & 16'h0081)     //  syndrome : 0x3e8
                                | ({16{i_sel[124]}} & 16'h0080)     //  syndrome : 0x13b
                                | ({16{i_sel[123]}} & 16'h0080)     //  syndrome : 0x73b
                                | ({16{i_sel[122]}} & 16'h0080)     //  syndrome : 0x43b
                                | ({16{i_sel[121]}} & 16'h0080)     //  syndrome : 0x5bb
                                | ({16{i_sel[120]}} & 16'h0080)     //  syndrome : 0x57b
                                | ({16{i_sel[119]}} & 16'h0080)     //  syndrome : 0x51b
                                | ({16{i_sel[118]}} & 16'h0080)     //  syndrome : 0x52b
                                | ({16{i_sel[117]}} & 16'h0080)     //  syndrome : 0x533
                                | ({16{i_sel[116]}} & 16'h0080)     //  syndrome : 0x53f
                                | ({16{i_sel[115]}} & 16'h0080)     //  syndrome : 0x539
                                | ({16{i_sel[114]}} & 16'h0080)     //  syndrome : 0x53a
                                | ({16{i_sel[113]}} & 16'h0060)     //  syndrome : 0x70e
                                | ({16{i_sel[112]}} & 16'h0050)     //  syndrome : 0x3e1
                                | ({16{i_sel[111]}} & 16'h0048)     //  syndrome : 0x6ff
                                | ({16{i_sel[110]}} & 16'h0044)     //  syndrome : 0x318
                                | ({16{i_sel[109]}} & 16'h0042)     //  syndrome : 0x682
                                | ({16{i_sel[108]}} & 16'h0041)     //  syndrome : 0x327
                                | ({16{i_sel[107]}} & 16'h0040)     //  syndrome : 0x1f4
                                | ({16{i_sel[106]}} & 16'h0040)     //  syndrome : 0x7f4
                                | ({16{i_sel[105]}} & 16'h0040)     //  syndrome : 0x4f4
                                | ({16{i_sel[104]}} & 16'h0040)     //  syndrome : 0x574
                                | ({16{i_sel[103]}} & 16'h0040)     //  syndrome : 0x5b4
                                | ({16{i_sel[102]}} & 16'h0040)     //  syndrome : 0x5d4
                                | ({16{i_sel[101]}} & 16'h0040)     //  syndrome : 0x5e4
                                | ({16{i_sel[100]}} & 16'h0040)     //  syndrome : 0x5fc
                                | ({16{i_sel[99 ]}} & 16'h0040)     //  syndrome : 0x5f0
                                | ({16{i_sel[98 ]}} & 16'h0040)     //  syndrome : 0x5f6
                                | ({16{i_sel[97 ]}} & 16'h0040)     //  syndrome : 0x5f5
                                | ({16{i_sel[96 ]}} & 16'h0030)     //  syndrome : 0x4ef
                                | ({16{i_sel[95 ]}} & 16'h0028)     //  syndrome : 0x1f1
                                | ({16{i_sel[94 ]}} & 16'h0024)     //  syndrome : 0x416
                                | ({16{i_sel[93 ]}} & 16'h0022)     //  syndrome : 0x18c
                                | ({16{i_sel[92 ]}} & 16'h0021)     //  syndrome : 0x429
                                | ({16{i_sel[91 ]}} & 16'h0020)     //  syndrome : 0x6fa
                                | ({16{i_sel[90 ]}} & 16'h0020)     //  syndrome : 0x0fa
                                | ({16{i_sel[89 ]}} & 16'h0020)     //  syndrome : 0x3fa
                                | ({16{i_sel[88 ]}} & 16'h0020)     //  syndrome : 0x27a
                                | ({16{i_sel[87 ]}} & 16'h0020)     //  syndrome : 0x2ba
                                | ({16{i_sel[86 ]}} & 16'h0020)     //  syndrome : 0x2da
                                | ({16{i_sel[85 ]}} & 16'h0020)     //  syndrome : 0x2ea
                                | ({16{i_sel[84 ]}} & 16'h0020)     //  syndrome : 0x2f2
                                | ({16{i_sel[83 ]}} & 16'h0020)     //  syndrome : 0x2fe
                                | ({16{i_sel[82 ]}} & 16'h0020)     //  syndrome : 0x2f8
                                | ({16{i_sel[81 ]}} & 16'h0020)     //  syndrome : 0x2fb
                                | ({16{i_sel[80 ]}} & 16'h0018)     //  syndrome : 0x51e
                                | ({16{i_sel[79 ]}} & 16'h0014)     //  syndrome : 0x0f9
                                | ({16{i_sel[78 ]}} & 16'h0012)     //  syndrome : 0x563
                                | ({16{i_sel[77 ]}} & 16'h0011)     //  syndrome : 0x0c6
                                | ({16{i_sel[76 ]}} & 16'h0010)     //  syndrome : 0x215
                                | ({16{i_sel[75 ]}} & 16'h0010)     //  syndrome : 0x415
                                | ({16{i_sel[74 ]}} & 16'h0010)     //  syndrome : 0x715
                                | ({16{i_sel[73 ]}} & 16'h0010)     //  syndrome : 0x695
                                | ({16{i_sel[72 ]}} & 16'h0010)     //  syndrome : 0x655
                                | ({16{i_sel[71 ]}} & 16'h0010)     //  syndrome : 0x635
                                | ({16{i_sel[70 ]}} & 16'h0010)     //  syndrome : 0x605
                                | ({16{i_sel[69 ]}} & 16'h0010)     //  syndrome : 0x61d
                                | ({16{i_sel[68 ]}} & 16'h0010)     //  syndrome : 0x611
                                | ({16{i_sel[67 ]}} & 16'h0010)     //  syndrome : 0x617
                                | ({16{i_sel[66 ]}} & 16'h0010)     //  syndrome : 0x614
                                | ({16{i_sel[65 ]}} & 16'h000c)     //  syndrome : 0x5e7
                                | ({16{i_sel[64 ]}} & 16'h000a)     //  syndrome : 0x07d
                                | ({16{i_sel[63 ]}} & 16'h0009)     //  syndrome : 0x5d8
                                | ({16{i_sel[62 ]}} & 16'h0008)     //  syndrome : 0x70b
                                | ({16{i_sel[61 ]}} & 16'h0008)     //  syndrome : 0x10b
                                | ({16{i_sel[60 ]}} & 16'h0008)     //  syndrome : 0x20b
                                | ({16{i_sel[59 ]}} & 16'h0008)     //  syndrome : 0x38b
                                | ({16{i_sel[58 ]}} & 16'h0008)     //  syndrome : 0x34b
                                | ({16{i_sel[57 ]}} & 16'h0008)     //  syndrome : 0x32b
                                | ({16{i_sel[56 ]}} & 16'h0008)     //  syndrome : 0x31b
                                | ({16{i_sel[55 ]}} & 16'h0008)     //  syndrome : 0x303
                                | ({16{i_sel[54 ]}} & 16'h0008)     //  syndrome : 0x30f
                                | ({16{i_sel[53 ]}} & 16'h0008)     //  syndrome : 0x309
                                | ({16{i_sel[52 ]}} & 16'h0008)     //  syndrome : 0x30a
                                | ({16{i_sel[51 ]}} & 16'h0006)     //  syndrome : 0x59a
                                | ({16{i_sel[50 ]}} & 16'h0005)     //  syndrome : 0x03f
                                | ({16{i_sel[49 ]}} & 16'h0004)     //  syndrome : 0x2ec
                                | ({16{i_sel[48 ]}} & 16'h0004)     //  syndrome : 0x4ec
                                | ({16{i_sel[47 ]}} & 16'h0004)     //  syndrome : 0x7ec
                                | ({16{i_sel[46 ]}} & 16'h0004)     //  syndrome : 0x66c
                                | ({16{i_sel[45 ]}} & 16'h0004)     //  syndrome : 0x6ac
                                | ({16{i_sel[44 ]}} & 16'h0004)     //  syndrome : 0x6cc
                                | ({16{i_sel[43 ]}} & 16'h0004)     //  syndrome : 0x6fc
                                | ({16{i_sel[42 ]}} & 16'h0004)     //  syndrome : 0x6e4
                                | ({16{i_sel[41 ]}} & 16'h0004)     //  syndrome : 0x6e8
                                | ({16{i_sel[40 ]}} & 16'h0004)     //  syndrome : 0x6ee
                                | ({16{i_sel[39 ]}} & 16'h0004)     //  syndrome : 0x6ed
                                | ({16{i_sel[38 ]}} & 16'h0003)     //  syndrome : 0x5a5
                                | ({16{i_sel[37 ]}} & 16'h0002)     //  syndrome : 0x776
                                | ({16{i_sel[36 ]}} & 16'h0002)     //  syndrome : 0x176
                                | ({16{i_sel[35 ]}} & 16'h0002)     //  syndrome : 0x276
                                | ({16{i_sel[34 ]}} & 16'h0002)     //  syndrome : 0x3f6
                                | ({16{i_sel[33 ]}} & 16'h0002)     //  syndrome : 0x336
                                | ({16{i_sel[32 ]}} & 16'h0002)     //  syndrome : 0x356
                                | ({16{i_sel[31 ]}} & 16'h0002)     //  syndrome : 0x366
                                | ({16{i_sel[30 ]}} & 16'h0002)     //  syndrome : 0x37e
                                | ({16{i_sel[29 ]}} & 16'h0002)     //  syndrome : 0x372
                                | ({16{i_sel[28 ]}} & 16'h0002)     //  syndrome : 0x374
                                | ({16{i_sel[27 ]}} & 16'h0002)     //  syndrome : 0x377
                                | ({16{i_sel[26 ]}} & 16'h0001)     //  syndrome : 0x2d3
                                | ({16{i_sel[25 ]}} & 16'h0001)     //  syndrome : 0x4d3
                                | ({16{i_sel[24 ]}} & 16'h0001)     //  syndrome : 0x7d3
                                | ({16{i_sel[23 ]}} & 16'h0001)     //  syndrome : 0x653
                                | ({16{i_sel[22 ]}} & 16'h0001)     //  syndrome : 0x693
                                | ({16{i_sel[21 ]}} & 16'h0001)     //  syndrome : 0x6f3
                                | ({16{i_sel[20 ]}} & 16'h0001)     //  syndrome : 0x6c3
                                | ({16{i_sel[19 ]}} & 16'h0001)     //  syndrome : 0x6db
                                | ({16{i_sel[18 ]}} & 16'h0001)     //  syndrome : 0x6d7
                                | ({16{i_sel[17 ]}} & 16'h0001)     //  syndrome : 0x6d1
                                | ({16{i_sel[16 ]}} & 16'h0001)     //  syndrome : 0x6d2
                                | ({16{i_sel[15 ]}} & 16'h8000)     //  syndrome : 0x689
                                | ({16{i_sel[14 ]}} & 16'h4000)     //  syndrome : 0x345
                                | ({16{i_sel[13 ]}} & 16'h2000)     //  syndrome : 0x1a3
                                | ({16{i_sel[12 ]}} & 16'h1000)     //  syndrome : 0x7b8
                                | ({16{i_sel[11 ]}} & 16'h0800)     //  syndrome : 0x3dc
                                | ({16{i_sel[10 ]}} & 16'h0400)     //  syndrome : 0x1ee
                                | ({16{i_sel[9  ]}} & 16'h0200)     //  syndrome : 0x79f
                                | ({16{i_sel[8  ]}} & 16'h0100)     //  syndrome : 0x4a6
                                | ({16{i_sel[7  ]}} & 16'h0080)     //  syndrome : 0x53b
                                | ({16{i_sel[6  ]}} & 16'h0040)     //  syndrome : 0x5f4
                                | ({16{i_sel[5  ]}} & 16'h0020)     //  syndrome : 0x2fa
                                | ({16{i_sel[4  ]}} & 16'h0010)     //  syndrome : 0x615
                                | ({16{i_sel[3  ]}} & 16'h0008)     //  syndrome : 0x30b
                                | ({16{i_sel[2  ]}} & 16'h0004)     //  syndrome : 0x6ec
                                | ({16{i_sel[1  ]}} & 16'h0002)     //  syndrome : 0x376
                                | ({16{i_sel[0  ]}} & 16'h0001);    //  syndrome : 0x6d3
endfunction
