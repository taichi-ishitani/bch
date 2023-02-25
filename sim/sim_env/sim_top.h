/**
 *  @file   sim_top.h
 *  @brief  検証環境トップ
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/31  T. Ishitani     coding start
 */

#ifndef SIM_TOP_H_
#define SIM_TOP_H_

#include <vector>
#include <sstream>
#include "scv.h"
#include "enc_env.h"
#include "dec_env.h"
#include "error_injector.h"
#include "utility.h"
#include "verilated_vcd_sc.h"

using namespace std;

#ifndef DUMP_LEVEL
#define DUMP_LEVEL  1
#endif

template <int W = 16, int E = 2, BchEnable ExtendOn = Enable, typename DataT = uint32_t, typename CodeT = uint32_t>
class SimTop :
    public  sc_module
{
    BchTypeDefine(W, E, ExtendOn)
    typedef EncEnv<W, E, ExtendOn, DataT, CodeT>    enc_env_t;
    typedef DecEnv<W, E, ExtendOn, DataT, CodeT>    dec_env_t;
    typedef ErrorInjector<W, E, ExtendOn>           error_injector_t;

public:

    typedef SimTop<W, E, ExtendOn, DataT, CodeT>    SC_CURRENT_USER_MODULE;
    SimTop(const sc_module_name& name);

    virtual ~SimTop();

    virtual void start_of_simulation();
    virtual void end_of_simulation();

protected:
    sc_clock            clk;
    sc_signal<bool>     rst_x;

    enc_env_t*          enc_env;
    dec_env_t*          dec_env;
    error_injector_t*   error_injector;

    sc_fifo<data_t>*    enc_data_fifo;
    sc_fifo<code_t>*    enc_code_fifo;
    sc_fifo<code_t>*    dec_code_fifo;
    sc_fifo<code_t>*    pattern_fifo;

    data_t              data;
    vector<code_t>      error_pattern;
    code_t              pattern;

    VerilatedVcdSc*     dump_dut;
    sc_trace_file*      dump_env;

    uint64_t            input_num;
    uint64_t            output_num;
    bool                main_thread_done;

    void main_thread();
    void monitor_thread();

    void main_core();

    void do_reset();
};

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
SimTop<W, E, ExtendOn, DataT, CodeT>::SimTop(const sc_module_name& name) :
    sc_module           (name),
    clk                 ("clk", 10, SC_NS),
    input_num           (0),
    output_num          (0),
    main_thread_done    (false)
{
    SC_THREAD(main_thread);
    SC_THREAD(monitor_thread);

    enc_env         = new enc_env_t("enc_env");
    dec_env         = new dec_env_t("dec_env");
    error_injector  = new error_injector_t("error_injector");
    enc_data_fifo   = new sc_fifo<data_t>;
    enc_code_fifo   = new sc_fifo<code_t>;
    dec_code_fifo   = new sc_fifo<code_t>;
    pattern_fifo    = new sc_fifo<code_t>;

    enc_env->clk(clk);
    enc_env->rst_x(rst_x);
    enc_env->data_in_if(*enc_data_fifo);
    enc_env->code_out_if(*enc_code_fifo);
    dec_env->clk(clk);
    dec_env->rst_x(rst_x);
    dec_env->code_in_if(*dec_code_fifo);
    error_injector->code_in_if(*enc_code_fifo);
    error_injector->code_out_if(*dec_code_fifo);
    error_injector->pattern_if(*pattern_fifo);

}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
SimTop<W, E, ExtendOn, DataT, CodeT>::~SimTop() {
    delete  enc_env;
    delete  dec_env;
    delete  error_injector;
    delete  enc_data_fifo;
    delete  enc_code_fifo;
    delete  dec_code_fifo;
    delete  pattern_fifo;
#ifdef DUMP_DUT
    delete  dump_dut;
#endif
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void SimTop<W, E, ExtendOn, DataT, CodeT>::start_of_simulation() {
#ifdef DUMP_DUT
    Verilated::traceEverOn(true);
    dump_dut    = new VerilatedVcdSc;
    enc_env->trace(dump_dut, DUMP_LEVEL);
    dec_env->trace(dump_dut, DUMP_LEVEL);
    dump_dut->open("dump/dump_dut.vcd");
#endif
#ifdef DUMP_ENV
     dump_env   = sc_create_vcd_trace_file("dump/dump_env");
     enc_env->trace(dump_env);
     dec_env->trace(dump_env);
     error_injector->trace(dump_env);
#endif
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void SimTop<W, E, ExtendOn, DataT, CodeT>::end_of_simulation() {
#ifdef DUMP_DUT
    dump_dut->close();
#endif
#ifdef DUMP_ENV
    sc_close_vcd_trace_file(dump_env);
#endif
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void SimTop<W, E, ExtendOn, DataT, CodeT>::main_thread() {
    do_reset();
    main_core();
    main_thread_done    = true;
}
/*
template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void SimTop<W, E, ExtendOn, DataT, CodeT>::main_core() {
    uint64_t        max_count   = (1UL << constants::data_width);
    int             error_num   = E + 1;
    stringstream    message;

    for (int e = 0;e <= error_num;e++) {
        message.str("");
        message.clear();
        message << sc_time_stamp()
                << "\nError Num :: " << e;
        SC_REPORT_INFO(name(), message.str().c_str());

        error_pattern.clear();
        if (e == 0) {
            error_pattern.push_back(0);
        }
        else {
            error_pattern_gen(constants::code_width, e, error_pattern);
        }
        for (uint64_t i = 0;i < max_count;i += 0x10000) {
            data    = i;
            for (size_t j = 0;j < error_pattern.size();j++) {
                pattern = error_pattern.at(j);
                enc_data_fifo->write(data);
                pattern_fifo->write(pattern);
                input_num   += 1;
            }
        }
    }
}
*/
template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void SimTop<W, E, ExtendOn, DataT, CodeT>::main_core() {
    const   uint64_t        max = (0x1UL << constants::data_width) - 1;
    scv_smart_ptr<data_t>   random_data("randam_data");
    stringstream            message;

    random_data->keep_only(0, max);
    for (int e = 0;e <= (E + 1);e++) {
        message.str("");
        message.clear();
        message << sc_time_stamp()
                << "\nError Num :: " << e;
        SC_REPORT_INFO(name(), message.str().c_str());

        error_pattern.clear();
        if (e == 0) {
            error_pattern.push_back(0);
        }
        else {
            error_pattern_gen(constants::code_width, e, error_pattern);
        }

        for (size_t i = 0;i < error_pattern.size();i++) {
            pattern = error_pattern.at(i);
            for (int j = 0;j < 100;j++) {
                random_data->next();
                data    = random_data->read();
                enc_data_fifo->write(data);
                pattern_fifo->write(pattern);
                input_num   += 1;
            }
        }
    }
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void SimTop<W, E, ExtendOn, DataT, CodeT>::monitor_thread() {
    while (1) {
        wait(dec_env->received);
        output_num  += 1;
        if (main_thread_done && (input_num <= output_num)) {
            break;
        }
    }
    wait(50, SC_NS);
    sc_stop();
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void SimTop<W, E, ExtendOn, DataT, CodeT>::do_reset() {
    rst_x.write(1);
    wait(60, SC_NS);
    rst_x.write(0);
    wait(60, SC_NS);
    rst_x.write(1);
    wait(60, SC_NS);
}

#endif /* SIM_TOP_H_ */
