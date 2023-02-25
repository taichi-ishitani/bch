/**
 *  @file   dec_env.h
 *  @brief
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/04/01  T. Ishitani     coding start
 */

#ifndef DEC_ENV_H_
#define DEC_ENV_H_

#include <sstream>
#include "bch.h"
#include "bch_dec_dut.h"

using namespace std;

template <int W = 16, int E = 2, BchEnable ExtendOn = Enable, typename DataT = uint32_t, typename CodeT = uint32_t>
class DecEnv :
    public  sc_module,
    public  BchCtrlIf
{
    BchTypeDefine(W, E, ExtendOn)

    typedef BchDecDut<W, E, ExtendOn, DataT, CodeT> dut_t;
    typedef BchDec<W, E, ExtendOn>                  model_t;

public:
    sc_in_clk                   clk;
    sc_in<bool>                 rst_x;
    sc_port<code_in_if_t>       code_in_if;
    sc_export<ctrl_if_t>        ctrl_if;
    sc_event                    received;

    typedef DecEnv<W, E, ExtendOn, DataT, CodeT>    SC_CURRENT_USER_MODULE;
    DecEnv(const sc_module_name& name);

    virtual ~DecEnv();

    virtual void set_enable();
    virtual void set_disable();

    virtual void trace(sc_trace_file* tr) const;
    void trace(VerilatedVcdSc* tr, int level);

protected:
    dut_t*              dut;
    model_t*            model;

    sc_fifo<code_t>*    dut_code_fifo;
    sc_fifo<code_t>*    model_code_fifo;
    sc_fifo<result_t>*  dut_result_fifo;
    sc_fifo<result_t>*  model_result_fifo;

    code_t              code;
    result_t            result_dut;
    result_t            resutl_model;

    void input_thread();
    void output_thread();

    void compare();

};

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
DecEnv<W, E, ExtendOn, DataT, CodeT>::DecEnv(const sc_module_name& name) :
    sc_module   (name)
{
    SC_THREAD(input_thread);
    SC_THREAD(output_thread);

    dut             = new dut_t("dut");
    dut_code_fifo   = new sc_fifo<code_t>;
    dut_result_fifo = new sc_fifo<result_t>;
    dut->clk(clk);
    dut->rst_x(rst_x);
    dut->code_in_if(*dut_code_fifo);
    dut->result_out_if(*dut_result_fifo);

    model               = new model_t("model");
    model_code_fifo     = new sc_fifo<code_t>;
    model_result_fifo   = new sc_fifo<result_t>;
    model->code_in_if(*model_code_fifo);
    model->result_out_if(*model_result_fifo);

    ctrl_if.bind(*this);
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
DecEnv<W, E, ExtendOn, DataT, CodeT>::~DecEnv() {
    delete dut;
    delete model;

    delete dut_code_fifo;
    delete model_code_fifo;
    delete dut_result_fifo;
    delete model_result_fifo;
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void DecEnv<W, E, ExtendOn, DataT, CodeT>::set_enable() {
    dut->set_enable();
    model->set_enable();
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void DecEnv<W, E, ExtendOn, DataT, CodeT>::set_disable() {
    dut->set_disable();
    model->set_disable();
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void DecEnv<W, E, ExtendOn, DataT, CodeT>::trace(sc_trace_file* tr) const {
    dut->trace(tr);
    model->trace(tr);
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void DecEnv<W, E, ExtendOn, DataT, CodeT>::trace(VerilatedVcdSc* tr, int level) {
    dut->trace(tr, level);
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void DecEnv<W, E, ExtendOn, DataT, CodeT>::input_thread() {
    while (1) {
        code_in_if->read(code);
        dut_code_fifo->write(code);
        model_code_fifo->write(code);
    }
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void DecEnv<W, E, ExtendOn, DataT, CodeT>::output_thread() {
    while (1) {
        dut_result_fifo->read(result_dut);
        model_result_fifo->read(resutl_model);
        compare();
        received.notify();
    }
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void DecEnv<W, E, ExtendOn, DataT, CodeT>::compare() {
    stringstream    message;

    if (result_dut == resutl_model) {
#ifdef VERBOSE
        message << sc_time_stamp()
                << "\nDecoder Output :: " << resutl_model;
        SC_REPORT_INFO(name(), message.str().c_str());
#endif
    }
    else {
        message << sc_time_stamp()
                << "\nDut   :: " << result_dut
                << "\nModel :: " << resutl_model;
        SC_REPORT_ERROR(name(), message.str().c_str());
    }
}

#endif /* DEC_ENV_H_ */
