/**
 *  @file   bch_base.h
 *  @brief  ユーティリティ関数
 *
 *  Copyright: (C) 2012 Taichi Ishitani All rights reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/25  T. Ishitani     coding start
 */

#ifndef BCH_BASE_H_
#define BCH_BASE_H_

#include <vector>

using namespace std;

enum BchDecodeStatus {
    ErrorNon,       //!<    エラーなし
    ErrorCorrected, //!<    エラー訂正
    ErrorDetected   //!<    エラー検出
};

enum BchEnable {
    Disable,
    Enable
};

/**
 * @brief   エラーパターンを生成する
 * @param   w       パターン幅
 * @param   e       エラーの個数
 * @param   pattern 出力パターン
 */
template <typename T>
void error_pattern_gen(int w, int e, vector<T>& pattern) {
    if (e == 1) {
        for (int i = 0;i < w;i++) {
            T   temp;
            temp    = (1 << (w - i - 1));
            pattern.push_back(temp);
        }
    }
    else {
        vector<T>   temp_pattern;
        for (int i = 0;i < w;i++) {
            error_pattern_gen(w - i - 1, e - 1, temp_pattern);
            for (unsigned int j = 0;j < temp_pattern.size();j++) {
                T   temp;
                temp    = (1 << (w - i - 1)) | temp_pattern.at(j);
                pattern.push_back(temp);
            }
            temp_pattern.clear();
        }
    }
}

/**
 * @brief   パリティを計算する
 * @param   width           入力データ幅
 * @param   data            入力データ
 * @param   parity_matrix   パリティ行列
 * @return  計算したパリティ
 */
template <typename T>
T calc_parity(int width, T data, vector<T>& parity_matrix) {
    int parity_width    = parity_matrix.size();
    T   parity          = 0;

    for (int i = 0;i < parity_width;i++) {
        T   temp    = parity_matrix.at(i) & data;
        T   bit     = 0;
        for (int j = 0;j < width;j++) {
            bit ^= ((temp >> j) & 1);
        }
        parity  |= (bit << i);
    }

    return parity;
}

/**
 * @brief   シンドロームを計算する
 * @param   width           入力コード幅
 * @param   code            入力コード
 * @param   parity_matrix   パリティ行列
 * @return  計算したシンドローム
 */
template <typename T>
T calc_syndrome(int width, T code, vector<T>& parity_matrix) {
    int parity_width    = parity_matrix.size();
    int data_width      = width - parity_width;
    T   data            = code >> parity_width;
    T   parity          = calc_parity(data_width, data, parity_matrix);
    T   syndrome        = (code & ((1 << parity_width) - 1)) ^ parity;
    return syndrome;
}

#endif /* BCH_BASE_H_ */
