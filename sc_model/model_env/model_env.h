/**
 *  @file   model_env.h
 *  @brief
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/29  T. Ishitani     coding start
 */

#ifndef MODEL_ENV_H_
#define MODEL_ENV_H_

#include <iostream>
#include <vector>
#include <stdint.h>
#include "bch.h"
#include "utility.h"

template <int W = 16, int E = 2, BchEnable ExtendOn = Enable>
class model_env :
    public sc_module
{
    BchTypeDefine(W, E, ExtendOn)
    typedef BchEnc<W, E, ExtendOn>  enc_t;
    typedef BchDec<W, E, ExtendOn>  dec_t;

public:
    typedef model_env<W, E, ExtendOn>   SC_CURRENT_USER_MODULE;
    model_env(const sc_module_name& name) :
        sc_module   (name)
    {
        SC_THREAD(main_thread);

        enc             = new enc_t("enc");
        dec             = new dec_t("dec");
        enc_data_fifo   = new sc_fifo<data_t>;
        enc_code_fifo   = new sc_fifo<code_t>;
        dec_code_fifo   = new sc_fifo<code_t>;
        dec_result_fifo = new sc_fifo<result_t>;

        enc->data_in_if(*enc_data_fifo);
        enc->code_out_if(*enc_code_fifo);

        dec->code_in_if(*dec_code_fifo);
        dec->result_out_if(*dec_result_fifo);
    }

protected:
    enc_t*              enc;
    dec_t*              dec;
    sc_fifo<data_t>*    enc_data_fifo;
    sc_fifo<code_t>*    enc_code_fifo;
    sc_fifo<code_t>*    dec_code_fifo;
    sc_fifo<result_t>*  dec_result_fifo;
    data_t              data;
    code_t              code;
    result_t            result;
    vector<code_t>      error_pattern;

    void main_thread() {
        int     t   = 0;
        bool    unmatch;
        int64_t max_count   = (1L << constants::data_width);
        int     error_num   = E + 1;

        for (int e = 0;e <= error_num;e++) {
            cout << "Error Num = " << e << endl;
            error_pattern.clear();
            if (e == 0) {
                error_pattern.push_back(0);
            }
            else {
                error_pattern_gen(constants::code_width, e, error_pattern);
            }
            for (int64_t i = 0;i < max_count;i += 0x10000) {
                for (size_t j = 0;j < error_pattern.size();j++) {
                    data    = i;
                    enc_data_fifo->write(data);

                    wait(10, SC_NS);
                    enc_code_fifo->read(code);
                    code    ^= error_pattern[j];
                    dec_code_fifo->write(code);

                    wait(10, SC_NS);
                    dec_result_fifo->read(result);

                    unmatch = false;
                    if (e == 0) {
                        if ((data != result.data) || (result.status != NoError)) {
                            unmatch = true;
                        }
                    }
                    else if (e <= E) {
                        if ((data != result.data) || (result.status != ErrorCorrected)) {
                            unmatch = true;
                        }
                    }
                    else {
                        if (result.status != ErrorDetected) {
                            unmatch = true;
                        }
                    }

                    if (unmatch) {
                        cout << "data : 0x" << hex << setw((W                     + 3) / 4) << internal << setfill('0') << data << endl;
                        cout << "code : 0x" << hex << setw((constants::code_width + 3) / 4) << internal << setfill('0') << code << endl;
                        cout << result << endl;
                        t   += 1;
                        if (t > 20) {
                            sc_stop();
                        }
                    }

                    wait(10, SC_NS);
                }
            }
        }
    }
};

#endif /* MODEL_ENV_H_ */
