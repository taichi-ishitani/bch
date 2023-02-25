/**
 *  @file   bch_dec.h
 *  @brief  BCH符号デコーダモデル
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/29  T. Ishitani     coding start
 */

#ifndef BCH_DEC_H_
#define BCH_DEC_H_

#include "bch_type.h"
#include "bch_base.h"

template <int W = 16, int E = 2, BchEnable ExtendOn = Enable>
class BchDec :
    public  sc_module,
    public  BchCtrlIf
{
    BchTypeDefine(W, E, ExtendOn)

public:
    sc_port<code_in_if_t>       code_in_if;
    sc_port<result_out_if_t>    result_out_if;
    sc_export<ctrl_if_t>        ctrl_if;

    typedef BchDec<W, E, ExtendOn>  SC_CURRENT_USER_MODULE;
    BchDec(const sc_module_name& name);

    virtual void set_enable();
    virtual void set_disable();

    virtual void trace(sc_trace_file* tr) const;

protected:
    enable_t    enable;
    data_t      parity_matrix[constants::parity_width];
    syndrome_t  syndrome_pattern[constants::syndrome_num];

    code_t      code;
    parity_t    syndrome;
    code_t      error;
    code_t      corrected_code;
    result_t    resut;

    void main_thread();
    void decode_core();
};

template <int W, int E, BchEnable ExtendOn>
BchDec<W, E, ExtendOn>::BchDec(const sc_module_name& name) :
    sc_module   (name),
    enable      (Enable)
{
    ctrl_if(*this);
    SC_THREAD(main_thread);

    //  パリティ行列/シンドロームパターンをセット
    set_parity_matrix<W, E, ExtendOn>(parity_matrix);
    set_syndrome_pattern<W, E, ExtendOn>(syndrome_pattern);
}

template <int W, int E, BchEnable ExtendOn>
void BchDec<W, E, ExtendOn>::set_enable() {
    enable  = Enable;
}

template <int W, int E, BchEnable ExtendOn>
void BchDec<W, E, ExtendOn>::set_disable() {
    enable  = Disable;
}

template <int W, int E, BchEnable ExtendOn>
void BchDec<W, E, ExtendOn>::trace(sc_trace_file* tr) const {
    sc_trace(tr, code          , string(name()) + ".code"          );
    sc_trace(tr, syndrome      , string(name()) + ".syndrome"      );
    sc_trace(tr, error         , string(name()) + ".error"         );
    sc_trace(tr, corrected_code, string(name()) + ".corrected_code");
    sc_trace(tr, resut         , string(name()) + ".result"        );
}

template <int W, int E, BchEnable ExtendOn>
void BchDec<W, E, ExtendOn>::main_thread() {
    while (1) {
        code_in_if->read(code);
        decode_core();
        result_out_if->write(resut);
    }
}

template <int W, int E, BchEnable ExtendOn>
void BchDec<W, E, ExtendOn>::decode_core() {
    bool    serch_result;

    if (enable == Enable) {
        calc_syndrome<W, E, ExtendOn>(code, syndrome, parity_matrix);
    }
    else {
        syndrome    = 0;
    }

    if (syndrome == 0) {
        error           = 0;
        resut.status    = NoError;
    }
    else {
        serch_result    = search_error_patten<W, E, ExtendOn>(syndrome, error, syndrome_pattern);
        resut.status    = (serch_result) ? ErrorCorrected : ErrorDetected;
    }
    corrected_code  = code ^ error;
    resut.data      = corrected_code.range(constants::code_width - 1, constants::parity_width);
}

#endif /* BCH_DEC_H_ */
