/**
 *  @file   enc_env.h
 *  @brief  BCH符号エンコーダ動作環境
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/31  T. Ishitani     coding start
 */

#ifndef ENC_ENV_H_
#define ENC_ENV_H_

#include <sstream>
#include "bch.h"
#include "bch_enc_dut.h"

using namespace std;

template <int W = 16, int E = 2, BchEnable ExtendOn = Enable, typename DataT = uint32_t, typename CodeT = uint32_t>
class EncEnv :
    public  sc_module,
    public  BchCtrlIf
{
    BchTypeDefine(W, E, ExtendOn)

    typedef BchEncDut<W, E, ExtendOn, DataT, CodeT> dut_t;
    typedef BchEnc<W, E, ExtendOn>                  model_t;

public:
    sc_in_clk               clk;
    sc_in<bool>             rst_x;
    sc_port<data_in_if_t>   data_in_if;
    sc_port<code_out_if_t>  code_out_if;
    sc_export<ctrl_if_t>    ctrl_if;

    typedef EncEnv<W, E, ExtendOn, DataT, CodeT>    SC_CURRENT_USER_MODULE;
    EncEnv(const sc_module_name& name);

    virtual ~EncEnv();

    virtual void set_enable();
    virtual void set_disable();

    virtual void trace(sc_trace_file* tr) const;
    void trace(VerilatedVcdSc* tr, int level);

protected:
    dut_t*              dut;
    model_t*            model;

    sc_fifo<data_t>*    dut_data_fifo;
    sc_fifo<data_t>*    model_data_fifo;
    sc_fifo<code_t>*    dut_code_fifo;
    sc_fifo<code_t>*    model_code_fifo;

    data_t              data;
    code_t              dut_code;
    code_t              model_code;

    void input_thread();
    void output_thread();

    void compare();

};

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
EncEnv<W, E, ExtendOn, DataT, CodeT>::EncEnv(const sc_module_name& name) :
    sc_module   (name)
{
    SC_THREAD(input_thread);
    SC_THREAD(output_thread);

    dut             = new dut_t("dut");
    dut_data_fifo   = new sc_fifo<data_t>;
    dut_code_fifo   = new sc_fifo<code_t>;
    dut->clk(clk);
    dut->rst_x(rst_x);
    dut->data_in_if(*dut_data_fifo);
    dut->code_out_if(*dut_code_fifo);

    model           = new model_t("model");
    model_data_fifo = new sc_fifo<data_t>;
    model_code_fifo = new sc_fifo<code_t>;
    model->data_in_if(*model_data_fifo);
    model->code_out_if(*model_code_fifo);

    ctrl_if.bind(*this);
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
EncEnv<W, E, ExtendOn, DataT, CodeT>::~EncEnv() {
    delete dut;
    delete model;

    delete dut_data_fifo;
    delete model_data_fifo;
    delete dut_code_fifo;
    delete model_code_fifo;
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void EncEnv<W, E, ExtendOn, DataT, CodeT>::set_enable() {
    dut->set_enable();
    model->set_enable();
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void EncEnv<W, E, ExtendOn, DataT, CodeT>::set_disable() {
    dut->set_disable();
    model->set_disable();
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void EncEnv<W, E, ExtendOn, DataT, CodeT>::trace(sc_trace_file* tr) const {
    dut->trace(tr);
    model->trace(tr);
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void EncEnv<W, E, ExtendOn, DataT, CodeT>::trace(VerilatedVcdSc* tr, int level) {
    dut->trace(tr, level);
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void EncEnv<W, E, ExtendOn, DataT, CodeT>::input_thread() {
    while (1) {
        data_in_if->read(data);
        dut_data_fifo->write(data);
        model_data_fifo->write(data);
    }
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void EncEnv<W, E, ExtendOn, DataT, CodeT>::output_thread() {
    while (1) {
        dut_code_fifo->read(dut_code);
        model_code_fifo->read(model_code);
        compare();
        code_out_if->write(model_code);
    }
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void EncEnv<W, E, ExtendOn, DataT, CodeT>::compare() {
    const int       print_width = (constants::code_width + 3) / 4;
    stringstream    message;

    if (dut_code == model_code) {
#ifdef VERBOSE
        message << sc_time_stamp()
                << "\nEncoder Output :: 0x" << hex << setw(print_width) << setfill('0') << model_code;
        SC_REPORT_INFO(name(), message.str().c_str());
#endif
    }
    else {
        message << sc_time_stamp()
                << "\nDut   :: 0x" << hex << setw(print_width) << setfill('0') << dut_code
                << "\nModel :: 0x" << hex << setw(print_width) << setfill('0') << model_code;
        SC_REPORT_ERROR(name(), message.str().c_str());
    }
}

#endif /* ENC_ENV_H_ */
