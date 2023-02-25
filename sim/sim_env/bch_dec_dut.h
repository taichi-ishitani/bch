/**
 *  @file   bch_dec_dut.h
 *  @brief  BCH符号デコーダDUTラッパ
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/04/01  T. Ishitani     coding start
 */

#ifndef BCH_DEC_DUT_H_
#define BCH_DEC_DUT_H_

#include "bch_type.h"
#include "Vdut_dec.h"
#include "verilated_vcd_sc.h"

template <int W = 16, int E = 2, BchEnable ExtendOn = Enable, typename DataT = uint32_t, typename CodeT = uint32_t>
class BchDecDut :
    public  sc_module,
    public  BchCtrlIf
{
    BchTypeDefine(W, E, ExtendOn)

public:
    sc_in_clk                   clk;
    sc_in<bool>                 rst_x;
    sc_port<code_in_if_t>       code_in_if;
    sc_port<result_out_if_t>    result_out_if;
    sc_export<ctrl_if_t>        ctrl_if;

    typedef BchDecDut<W, E, ExtendOn, DataT, CodeT> SC_CURRENT_USER_MODULE;
    BchDecDut(const sc_module_name& name);

    virtual ~BchDecDut();

    virtual void set_enable();
    virtual void set_disable();

    virtual void trace(sc_trace_file* tr) const;
    void trace(VerilatedVcdSc* tr, int level);

protected:
    code_t      code;
    result_t    result;
    enable_t    enable;

    //  DUT
    Vdut_dec*   dut;

    //  信号
    sc_signal<bool>     i_enable;
    sc_signal<bool>     i_code_valid;
    sc_signal<CodeT>    i_code;
    sc_signal<bool>     o_data_valid;
    sc_signal<DataT>    o_data;
    sc_signal<bool>     o_corrected;
    sc_signal<bool>     o_detected;

    void    input_thread();
    void    output_thread();

};

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
BchDecDut<W, E, ExtendOn, DataT, CodeT>::BchDecDut(const sc_module_name& name) :
    sc_module   (name),
    enable      (Enable)
{
    SC_CTHREAD(input_thread, clk.pos());
    reset_signal_is(rst_x, false);
    SC_CTHREAD(output_thread, clk.pos());

    dut = new Vdut_dec("dut");
    dut->clk(clk);
    dut->rst_x(rst_x);
    dut->i_enable(i_enable);
    dut->i_code_valid(i_code_valid);
    dut->i_code(i_code);
    dut->o_data_valid(o_data_valid);
    dut->o_data(o_data);
    dut->o_corrected(o_corrected);
    dut->o_detected(o_detected);

    ctrl_if.bind(*this);
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
BchDecDut<W, E, ExtendOn, DataT, CodeT>::~BchDecDut() {
    delete dut;
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void BchDecDut<W, E, ExtendOn, DataT, CodeT>::set_enable() {
    enable  = Enable;
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void BchDecDut<W, E, ExtendOn, DataT, CodeT>::set_disable() {
    enable  = Disable;
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void BchDecDut<W, E, ExtendOn, DataT, CodeT>::trace(sc_trace_file* tr) const {
    sc_trace(tr, code         , string(name()) + ".code"  );
    sc_trace(tr, result.data  , string(name()) + ".data"  );
    sc_trace(tr, result.status, string(name()) + ".status");
    sc_trace(tr, enable       , string(name()) + ".enable");
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void BchDecDut<W, E, ExtendOn, DataT, CodeT>::trace(VerilatedVcdSc* tr, int level) {
    dut->trace(tr, level);
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void BchDecDut<W, E, ExtendOn, DataT, CodeT>::input_thread() {
    //  リセット
    i_enable.write(enable);
    i_code_valid.write(0);
    i_code.write(0);

    while (1) {
        //  入力待ち
        while (code_in_if->num_available() == 0) {
            wait();
        }

        //  入力セット
        code_in_if->read(code);
        i_enable.write(enable);
        i_code_valid.write(1);
        i_code.write(code);

        wait();
        i_code_valid.write(0);
        i_code.write(0);
    }
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void BchDecDut<W, E, ExtendOn, DataT, CodeT>::output_thread() {
    while (1) {
        //  データ出力待ち
        while (o_data_valid.read() == 0) {
            wait();
        }

        //  データ取りだし
        result.data     = o_data.read();
        result.status   = (o_corrected.read() == 1) ? ErrorCorrected
                        : (o_detected.read()  == 1) ? ErrorDetected
                                                    : NoError;
        result_out_if->write(result);
        wait();
    }
}

#endif /* BCH_DEC_DUT_H_ */
