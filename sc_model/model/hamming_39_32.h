/**
 *  @file   hamming_39_32.h
 *  @brief
 *
 *  @par    Copyright
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/04/07  T. Ishitani     coding start
 */

#ifndef HAMMING_39_32_H_
#define HAMMING_39_32_H_

#include "bch_base.h"

template <>
struct BchConstants<32, 1, Enable> {
    static const int    data_width      = 32;
    static const int    parity_width    = 7;
    static const int    code_width      = 39;
    static const int    syndrome_num    = SyndromeNum<code_width, 1>::value;
};

template <>
void set_parity_matrix<32, 1, Enable>(
    sc_uint<BchConstants<32, 1, Enable>::data_width>    matrix[]
) {
    matrix[0]   = 0x1d0d73df;
    matrix[1]   = 0x27179461;
    matrix[2]   = 0x6938bca3;
    matrix[3]   = 0xd2717946;
    matrix[4]   = 0xa4e2f28c;
    matrix[5]   = 0x49c5e518;
    matrix[6]   = 0x938bca30;
}

template <>
void set_syndrome_pattern<32, 1, Enable>(
    BchSyndrome<32, 1, Enable> pattern[]
) {
    pattern[0 ].set(0x01, 0x0000000001);
    pattern[1 ].set(0x02, 0x0000000002);
    pattern[2 ].set(0x04, 0x0000000004);
    pattern[3 ].set(0x08, 0x0000000008);
    pattern[4 ].set(0x10, 0x0000000010);
    pattern[5 ].set(0x20, 0x0000000020);
    pattern[6 ].set(0x40, 0x0000000040);
    pattern[7 ].set(0x07, 0x0000000080);
    pattern[8 ].set(0x0d, 0x0000000100);
    pattern[9 ].set(0x19, 0x0000000200);
    pattern[10].set(0x31, 0x0000000400);
    pattern[11].set(0x61, 0x0000000800);
    pattern[12].set(0x46, 0x0000001000);
    pattern[13].set(0x0b, 0x0000002000);
    pattern[14].set(0x15, 0x0000004000);
    pattern[15].set(0x29, 0x0000008000);
    pattern[16].set(0x51, 0x0000010000);
    pattern[17].set(0x26, 0x0000020000);
    pattern[18].set(0x4c, 0x0000040000);
    pattern[19].set(0x1f, 0x0000080000);
    pattern[20].set(0x3d, 0x0000100000);
    pattern[21].set(0x79, 0x0000200000);
    pattern[22].set(0x76, 0x0000400000);
    pattern[23].set(0x6b, 0x0000800000);
    pattern[24].set(0x52, 0x0001000000);
    pattern[25].set(0x23, 0x0002000000);
    pattern[26].set(0x45, 0x0004000000);
    pattern[27].set(0x0e, 0x0008000000);
    pattern[28].set(0x1c, 0x0010000000);
    pattern[29].set(0x38, 0x0020000000);
    pattern[30].set(0x70, 0x0040000000);
    pattern[31].set(0x67, 0x0080000000);
    pattern[32].set(0x4a, 0x0100000000);
    pattern[33].set(0x13, 0x0200000000);
    pattern[34].set(0x25, 0x0400000000);
    pattern[35].set(0x49, 0x0800000000);
    pattern[36].set(0x16, 0x1000000000);
    pattern[37].set(0x2c, 0x2000000000);
    pattern[38].set(0x58, 0x4000000000);
}

#endif /* HAMMING_39_32_H_ */
