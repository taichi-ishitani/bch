/**
 *  @file   bch.h
 *  @brief  ２重誤り訂正BCH符号(Cモデル)
 *
 *  Copyright: (C) 2012 Taichi Ishitani All rights reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/25  T. Ishitani     coding start
 */

#ifndef BCH_H_
#define BCH_H_

#include <vector>
#include <map>
#include <stdint.h>
#include "bch_base.h"
#include "bch31.h"

using namespace std;

template <int data_width = 16, bool extended_on = true, typename T = uint32_t>
class Bch {
public:
    Bch() :
        enable  (Enable)
    {
        if (!setup_done) {
            setup();
        }
    }

    void encode(T data, T& code);
    void decode(T code, T& data, BchDecodeStatus& status);

    void set_enable() {
        enable  = Enable;
    }

    void set_disable() {
        enable  = Disable;
    }

    static int get_data_width() {
        return data_width;
    }

    static int get_parity_widt() {
        return parity_width;
    }

    static int get_code_width() {
        return code_width;
    }

protected:
    static int          parity_width;
    static int          code_width;
    static vector<T>    parity_matrix;
    static map<T, T>    syndrome_pattern;
    static bool         setup_done;

    BchEnable           enable;

    static void setup();
};

template <int data_width, bool extended_on, typename T>
int Bch<data_width, extended_on, T>::parity_width;

template <int data_width, bool extended_on, typename T>
int Bch<data_width, extended_on, T>::code_width;

template <int data_width, bool extended_on, typename T>
vector<T> Bch<data_width, extended_on, T>::parity_matrix;

template <int data_width, bool extended_on, typename T>
map<T, T> Bch<data_width, extended_on, T>::syndrome_pattern;

template <int data_width, bool extended_on, typename T>
bool Bch<data_width, extended_on, T>::setup_done = false;

template <int data_width, bool extended_on, typename T>
void Bch<data_width, extended_on, T>::setup() {
    vector<T>   error_patters;

    //  パリティ生成行列の設定
    if ((data_width >= 8) && (data_width <= 21)) {
        set_parity_matrix_bch31(parity_matrix);
    }

    //  拡大線形符号の設定
    if (extended_on) {
        T   additional_row  = 0;
        for (size_t i = 0;i < parity_matrix.size();i++) {
            additional_row  ^= parity_matrix[i];
        }
        additional_row  = (~additional_row) & ((1 << (data_width + parity_matrix.size())) - 1);
        parity_matrix.insert(parity_matrix.begin(), additional_row);
    }

    //  符号長の設定
    parity_width    = parity_matrix.size();
    code_width      = data_width + parity_width;

    //  シンドロームテーブルの生成
    for (int e = 1;e <= 2;e++) {
        error_patters.clear();
        error_pattern_gen(code_width, e, error_patters);
        for (size_t i = 0;i < error_patters.size();i++) {
            T   pattern     = error_patters[i];
            T   syndrome    = calc_syndrome(code_width, pattern, parity_matrix);
            syndrome_pattern.insert(pair<T, T>(syndrome, pattern));
        }
    }
}

template <int data_width, bool extended_on, typename T>
void Bch<data_width, extended_on, T>::encode(T data, T& code) {
    T   parity  = 0;

    if (enable == Enable) {
        parity  = calc_parity(data_width, data, parity_matrix);
    }

    code    = (data << parity_width) | parity;
}

template <int data_width, bool extended_on, typename T>
void Bch<data_width, extended_on, T>::decode(T code, T& data, BchDecodeStatus& status) {
    T   corrected_code;

    corrected_code  = code;
    status          = ErrorNon;
    if (enable == Enable) {
        T   syndrome    = calc_syndrome(code_width, code, parity_matrix);
        if (syndrome != 0) {
            typename map<T, T>::iterator pos    = syndrome_pattern.find(syndrome);
            if (pos != syndrome_pattern.end()) {
                T   pattern = pos->second;
                corrected_code  = corrected_code ^ pattern;
                status          = ErrorCorrected;
            }
            else {
                status  = ErrorDetected;
            }
        }
    }
    data    = corrected_code >> parity_width;
}

#endif /* BCH_H_ */
