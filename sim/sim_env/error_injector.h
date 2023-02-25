/**
 *  @file   error_injector.h
 *  @brief  エラー挿入モジュール
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/04/02  T. Ishitani     coding start
 */

#ifndef ERROR_INJECTOR_H_
#define ERROR_INJECTOR_H_

#include <sstream>
#include "bch_type.h"

using namespace std;

template <int W = 16, int E = 2, BchEnable ExtendOn = Enable>
class ErrorInjector :
    public  sc_module
{
    BchTypeDefine(W, E, ExtendOn)

public:
    sc_port<code_in_if_t>   code_in_if;
    sc_port<code_out_if_t>  code_out_if;
    sc_port<code_in_if_t>   pattern_if;

    typedef ErrorInjector<W, E, ExtendOn>   SC_CURRENT_USER_MODULE;
    ErrorInjector(const sc_module_name& name);

    virtual void trace(sc_trace_file* tr) const;

protected:
    code_t  input_code;
    code_t  output_code;
    code_t  error_pattern;

    void main_thread();

};

template <int W, int E, BchEnable ExtendOn>
ErrorInjector<W, E, ExtendOn>::ErrorInjector(const sc_module_name& name) :
    sc_module   (name)
{
    SC_THREAD(main_thread);
}

template <int W, int E, BchEnable ExtendOn>
void ErrorInjector<W, E, ExtendOn>::trace(sc_trace_file* tr) const {
    sc_trace(tr, input_code   , string(name()) + ".input_code"   );
    sc_trace(tr, output_code  , string(name()) + ".output_code"  );
    sc_trace(tr, error_pattern, string(name()) + ".error_pattern");
}

template <int W, int E, BchEnable ExtendOn>
void ErrorInjector<W, E, ExtendOn>::main_thread() {
#ifdef VERBOSE
    stringstream    message;
    const int       print_width = (constants::code_width + 3) / 4;
#endif

    while (1) {
        input_code      = code_in_if->read();
        error_pattern   = pattern_if->read();
        output_code     = input_code ^ error_pattern;
#ifdef VERBOSE
            message.str("");
            message.clear();
            message << sc_time_stamp()
                    << "\nInput Code    :: 0x" << hex << setw(print_width) << setfill('0') << input_code
                    << "\nOutput Code   :: 0x" << hex << setw(print_width) << setfill('0') << output_code
                    << "\nError Pattern :: 0x" << hex << setw(print_width) << setfill('0') << error_pattern;
            SC_REPORT_INFO(name(), message.str().c_str());
#endif
        code_out_if->write(output_code);
    }
}

#endif /* ERROR_INJECTOR_H_ */
