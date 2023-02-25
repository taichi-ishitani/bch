/**
 *  @file   main.cpp
 *  @brief
 *
 *  Copyright: (C) 2012 Taichi Ishitani All rights reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/25  T. Ishitani     coding start
 */

#include <cstdio>
#include <vector>
#include <map>
#include <stdint.h>
#include "bch.h"

using namespace std;

int main() {
    Bch<>*              bch;
    int                 max_count   = 1 << 16;
    uint32_t            in_data;
    uint32_t            out_code;
    uint32_t            in_code;
    uint32_t            out_data;
    BchDecodeStatus     status;
    vector<uint32_t>    error;
    bool                verbose     = false;
    int                 error_count = 0;

    bch = new Bch<>;
    error.push_back(0);
    for (int e = 1;e <= 2;e++) {
        error_pattern_gen(Bch<>::get_code_width(), e, error);
    }

    //max_count   = 10;
    for (int e = 0;e <= 3;e++) {
        printf("Error Num = %d\n", e);
        error.clear();
        if (e == 0) {
            error.push_back(0);
        }
        else {
            error_pattern_gen(Bch<>::get_code_width(), e, error);
        }
        for (size_t i = 0;i < error.size();i++) {
            for (int j = 0;j < max_count;j++) {
                bool    unmatch = false;

                in_data = j;
                bch->encode(in_data, out_code);
                in_code = out_code ^ error[i];
                bch->decode(in_code, out_data, status);

                if (e == 0) {
                    if ((in_data != out_data) || (status != ErrorNon)) {
                        unmatch = true;
                    }
                }
                else if ((e == 1) || (e == 2)) {
                    if ((in_data != out_data) || (status != ErrorCorrected)) {
                        unmatch = true;
                    }
                }
                else {
                    if (status != ErrorDetected) {
                        unmatch = true;
                    }
                }

                if (verbose || unmatch) {
                    error_count += 1;
                    printf("error   = %07x\n", error[i]);
                    printf("in_data = %07x out_code = %07x\n"             , in_data, out_code);
                    printf("in_code = %07x out_data = %07x status = %0d\n", in_code, out_data, status);
                }
                if (error_count >= 10) {
                    goto END;
                }
            }
        }
    }

    END:
    return 0;
}
