/**
 *  @file   bch31.h
 *  @brief
 *
 *  Copyright: (C) 2012 Taichi Ishitani All rights reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/25  T. Ishitani     coding start
 */

#ifndef BCH31_H_
#define BCH31_H_

#include <vector>
#include <map>
#include "bch_base.h"

template <typename T>
void set_parity_matrix_bch31(vector<T>& parity_matrix) {
    parity_matrix.push_back(0x0527ab);  //  10行目
    parity_matrix.push_back(0x0a4f56);  //  9行目
    parity_matrix.push_back(0x149eac);  //  8行目
    parity_matrix.push_back(0x0c1af3);  //  7行目
    parity_matrix.push_back(0x1835e6);  //  6行目
    parity_matrix.push_back(0x154c67);  //  5行目
    parity_matrix.push_back(0x0fbf65);  //  4行目
    parity_matrix.push_back(0x1f7eca);  //  3行目
    parity_matrix.push_back(0x1bda3f);  //  2行目
    parity_matrix.push_back(0x1293d5);  //  1行目
}

#endif /* BCH31_H_ */
