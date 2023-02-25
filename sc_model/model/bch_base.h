/**
 *  @file   bch_base.h
 *  @brief  モデル共通関数
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/28  T. Ishitani     coding start
 */

#ifndef BCH_BASE_H_
#define BCH_BASE_H_

#include "bch_type.h"

template <int W, int E, BchEnable ExtendOn>
void calc_parity(
    sc_uint<BchConstants<W, E, ExtendOn>::data_width>&      data,
    sc_uint<BchConstants<W, E, ExtendOn>::parity_width>&    parity,
    sc_uint<BchConstants<W, E, ExtendOn>::data_width>       matrix[]
) {
    sc_uint<BchConstants<W, E, ExtendOn>::data_width>   temp;

    for (int i = 0;i < BchConstants<W, E, ExtendOn>::parity_width;i++) {
        temp        = data & matrix[i];
        parity[i]   = temp.xor_reduce();
    }
}

template <int W, int E, BchEnable ExtendOn>
void calc_syndrome(
    sc_uint<BchConstants<W, E, ExtendOn>::code_width>&      code,
    sc_uint<BchConstants<W, E, ExtendOn>::parity_width>&    syndrome,
    sc_uint<BchConstants<W, E, ExtendOn>::data_width>       matrix[]
) {
    sc_uint<BchConstants<W, E, ExtendOn>::data_width>       data;
    sc_uint<BchConstants<W, E, ExtendOn>::parity_width>     parity;

    (data, parity)  = code;
    calc_parity<W, E, ExtendOn>(data, syndrome, matrix);
    syndrome    ^= parity;
}

template <int W, int E, BchEnable ExtendOn>
bool search_error_patten(
    sc_uint<BchConstants<W, E, ExtendOn>::parity_width>&    syndrome,
    sc_uint<BchConstants<W, E, ExtendOn>::code_width>&      error_pattern,
    BchSyndrome<W, E, ExtendOn>                             pattern[]
) {
    bool    result;

    error_pattern   = 0;
    result          = true;
    if (syndrome != 0) {
        result  = false;

        for (int i = 0;i < BchConstants<W, E, ExtendOn>::syndrome_num;i++) {
            if (syndrome == pattern[i].syndrome) {
                error_pattern   = pattern[i].error_pattern;
                result          = true;
                break;
            }
        }
    }

    return result;
}

template <int W, int E, BchEnable ExtendOn>
void set_parity_matrix(
    sc_uint<BchConstants<W, E, ExtendOn>::data_width>   matrix[]
) {
    SC_REPORT_FATAL("set_parity_matrix()", "This function is not implemented");
}

template <int W, int E, BchEnable ExtendOn>
void set_syndrome_pattern(
    BchSyndrome<W, E, ExtendOn> pattern[]
) {
    SC_REPORT_FATAL("set_syndrome_pattern()", "This function is not implemented");
}

#endif /* BCH_BASE_H_ */
