/**
 *  @file   bch_enc_dut.h
 *  @brief  BCH符号エンコーダDUTラッパ
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/31  T. Ishitani     coding start
 */

#ifndef BCH_ENC_DUT_H_
#define BCH_ENC_DUT_H_

#include "bch_type.h"
#include "Vdut_enc.h"
#include "verilated_vcd_sc.h"

template <int W = 16, int E = 2, BchEnable ExtendOn = Enable, typename DataT = uint32_t, typename CodeT = uint32_t>
class BchEncDut :
    public  sc_module,
    public  BchCtrlIf
{
    BchTypeDefine(W, E, ExtendOn)

public:
    sc_in_clk               clk;
    sc_in<bool>             rst_x;
    sc_port<data_in_if_t>   data_in_if;
    sc_port<code_out_if_t>  code_out_if;
    sc_export<ctrl_if_t>    ctrl_if;

    typedef BchEncDut<W, E, ExtendOn, DataT, CodeT> SC_CURRENT_USER_MODULE;
    BchEncDut(const sc_module_name& name);

    virtual ~BchEncDut();

    virtual void set_enable();
    virtual void set_disable();

    virtual void trace(sc_trace_file* tr) const;
    void trace(VerilatedVcdSc* tr, int level);

protected:
    data_t      data;
    code_t      code;
    enable_t    enable;

    //  DUT
    Vdut_enc*   dut;

    //  信号
    sc_signal<bool>     i_enable;
    sc_signal<bool>     i_data_valid;
    sc_signal<DataT>    i_data;
    sc_signal<bool>     o_code_valid;
    sc_signal<CodeT>    o_code;

    void    input_thread();
    void    output_thread();
};

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
BchEncDut<W, E, ExtendOn, DataT, CodeT>::BchEncDut(const sc_module_name& name) :
    sc_module   (name),
    enable      (Enable)
{
    SC_CTHREAD(input_thread, clk.pos());
    reset_signal_is(rst_x, false);
    SC_CTHREAD(output_thread, clk.pos());

    dut = new Vdut_enc("dut");
    dut->clk(clk);
    dut->rst_x(rst_x);
    dut->i_enable(i_enable);
    dut->i_data_valid(i_data_valid);
    dut->i_data(i_data);
    dut->o_code_valid(o_code_valid);
    dut->o_code(o_code);

    ctrl_if.bind(*this);
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
BchEncDut<W, E, ExtendOn, DataT, CodeT>::~BchEncDut() {
    delete dut;
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void BchEncDut<W, E, ExtendOn, DataT, CodeT>::set_enable() {
    enable  = Enable;
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void BchEncDut<W, E, ExtendOn, DataT, CodeT>::set_disable() {
    enable  = Disable;
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void BchEncDut<W, E, ExtendOn, DataT, CodeT>::trace(sc_trace_file* tr) const {
    sc_trace(tr, data  , string(name()) + ".data"  );
    sc_trace(tr, code  , string(name()) + ".code"  );
    sc_trace(tr, enable, string(name()) + ".enable");
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void BchEncDut<W, E, ExtendOn, DataT, CodeT>::trace(VerilatedVcdSc* tr, int level) {
    dut->trace(tr, level);
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void BchEncDut<W, E, ExtendOn, DataT, CodeT>::input_thread() {
    //  リセット
    i_enable.write(enable);
    i_data_valid.write(0);
    i_data.write(0);

    while (1) {
        //  入力待ち
        while (data_in_if->num_available() == 0) {
            wait();
        }

        //  入力セット
        data_in_if->read(data);
        i_enable.write(enable);
        i_data_valid.write(1);
        i_data.write(data);

        wait();
        i_data_valid.write(0);
        i_data.write(0);
    }
}

template <int W, int E, BchEnable ExtendOn, typename DataT, typename CodeT>
void BchEncDut<W, E, ExtendOn, DataT, CodeT>::output_thread() {
    while (1) {
        //  コード出力待ち
        while (o_code_valid.read() == 0) {
            wait();
        }

        //  コード取りだし
        code    = o_code.read();
        code_out_if->write(code);
        wait();
    }
}

#endif /* BCH_ENC_DUT_H_ */
