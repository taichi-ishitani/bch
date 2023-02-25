/**
 *  @file   utility.h
 *  @brief  ユーティリティ関数
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/04/02  T. Ishitani     coding start
 */

#ifndef UTILITY_H_
#define UTILITY_H_

#include <vector>

using namespace std;

template <typename T>
void error_pattern_gen(int w, int e, vector<T>& pattern) {
    if (e == 1) {
        for (int i = 0;i < w;i++) {
            pattern.push_back(1UL << (w - i - 1));
        }
    }
    else {
        vector<T>   temp_pattern;
        for (int i = 0;i < w;i++) {
            temp_pattern.clear();
            error_pattern_gen(w - i - 1, e - 1, temp_pattern);
            for (size_t j = 0;j < temp_pattern.size();j++) {
                pattern.push_back((1UL << (w - i - 1)) | temp_pattern.at(j));
            }
        }
    }
}

template <int n, int m>
struct Combination {
    enum {
        value   = n * Combination<n - 1, m - 1>::value / m
    };
};

template <int n>
struct Combination<n, 0> {
    enum {
        value   = 1
    };
};

template <int w, int e>
struct SyndromeNum {
    enum {
        value   = Combination<w, e>::value + Combination<w, e - 1>::value
    };
};

template <int w>
struct SyndromeNum<w, 1> {
    enum {
        value   = Combination<w, 1>::value
    };
};


#endif /* UTILITY_H_ */
