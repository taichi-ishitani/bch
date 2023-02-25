/**
 *  @file   hamming_22_16.h
 *  @brief
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/04/03  T. Ishitani     coding start
 */

#ifndef HAMMING_22_16_H_
#define HAMMING_22_16_H_

#include "bch_base.h"

template <>
struct BchConstants<16, 1, Enable> {
    static const int    data_width      = 16;
    static const int    parity_width    = 6;
    static const int    code_width      = 22;
    static const int    syndrome_num    = SyndromeNum<code_width, 1>::value;
};

template <>
void set_parity_matrix<16, 1, Enable>(
    sc_uint<BchConstants<16, 1, Enable>::data_width>    matrix[]
) {
    matrix[0]   = 0xea27;
    matrix[1]   = 0x3e69;
    matrix[2]   = 0x7cd2;
    matrix[3]   = 0xc7cd;
    matrix[4]   = 0x8f9a;
    matrix[5]   = 0x1f34;
}

template <>
void set_syndrome_pattern<16, 1, Enable>(
    BchSyndrome<16, 1, Enable> pattern[]
) {
    pattern[0 ].set(0x01, 0x000001);
    pattern[1 ].set(0x02, 0x000002);
    pattern[2 ].set(0x04, 0x000004);
    pattern[3 ].set(0x08, 0x000008);
    pattern[4 ].set(0x10, 0x000010);
    pattern[5 ].set(0x20, 0x000020);
    pattern[6 ].set(0x0b, 0x000040);
    pattern[7 ].set(0x15, 0x000080);
    pattern[8 ].set(0x29, 0x000100);
    pattern[9 ].set(0x1a, 0x000200);
    pattern[10].set(0x34, 0x000400);
    pattern[11].set(0x23, 0x000800);
    pattern[12].set(0x0e, 0x001000);
    pattern[13].set(0x1c, 0x002000);
    pattern[14].set(0x38, 0x004000);
    pattern[15].set(0x3b, 0x008000);
    pattern[16].set(0x3e, 0x010000);
    pattern[17].set(0x37, 0x020000);
    pattern[18].set(0x26, 0x040000);
    pattern[19].set(0x07, 0x080000);
    pattern[20].set(0x0d, 0x100000);
    pattern[21].set(0x19, 0x200000);
}

#endif /* HAMMING_22_16_H_ */
