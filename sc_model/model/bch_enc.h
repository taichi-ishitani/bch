/**
 *  @file   bch_enc.h
 *  @brief  BCH符号エンコーダモデル
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/29  T. Ishitani     coding start
 */

#ifndef BCH_ENC_H_
#define BCH_ENC_H_

#include "bch_type.h"
#include "bch_base.h"

template <int W = 16, int E = 2, BchEnable ExtendOn = Enable>
class BchEnc :
    public  sc_module,
    public  BchCtrlIf
{
    BchTypeDefine(W, E, ExtendOn)

public:
    sc_port<data_in_if_t>   data_in_if;
    sc_port<code_out_if_t>  code_out_if;
    sc_export<ctrl_if_t>    ctrl_if;

    typedef BchEnc<W, E, ExtendOn>  SC_CURRENT_USER_MODULE;
    BchEnc(const sc_module_name& name);

    virtual void set_enable();
    virtual void set_disable();

    virtual void trace(sc_trace_file* tr) const;

protected:
    enable_t    enable;
    data_t      parity_matrix[constants::parity_width];

    data_t      data;
    parity_t    parity;
    code_t      code;

    void main_thread();
    void encode_core();
};

template <int W, int E, BchEnable ExtendOn>
BchEnc<W, E, ExtendOn>::BchEnc(const sc_module_name& name) :
    sc_module   (name),
    enable      (Enable)
{
    ctrl_if(*this);
    SC_THREAD(main_thread);

    //  パリティ行列をセット
    set_parity_matrix<W, E, ExtendOn>(parity_matrix);
}

template <int W, int E, BchEnable ExtendOn>
void BchEnc<W, E, ExtendOn>::set_enable() {
    enable  = Enable;
}

template <int W, int E, BchEnable ExtendOn>
void BchEnc<W, E, ExtendOn>::set_disable() {
    enable  = Disable;
}

template <int W, int E, BchEnable ExtendOn>
void BchEnc<W, E, ExtendOn>::trace(sc_trace_file* tr) const {
    sc_trace(tr, data  , string(name()) + ".data"  );
    sc_trace(tr, parity, string(name()) + ".parity");
    sc_trace(tr, code  , string(name()) + ".code"  );
}

template <int W, int E, BchEnable ExtendOn>
void BchEnc<W, E, ExtendOn>::main_thread() {
    while (1) {
        data_in_if->read(data);
        encode_core();
        code_out_if->write(code);
    }
}

template <int W, int E, BchEnable ExtendOn>
void BchEnc<W, E, ExtendOn>::encode_core() {
    if (enable == Enable) {
        calc_parity<W, E, ExtendOn>(data, parity, parity_matrix);
    }
    else {
        parity  = 0;
    }
    code    = (data, parity);
}

#endif /* BCH_ENC_H_ */
