/**
 *  @file   bch_type.h
 *  @brief
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/27  T. Ishitani     coding start
 */

#ifndef BCH_TYPE_H_
#define BCH_TYPE_H_

#include <iostream>
#include <iomanip>
#include <string>
#include "systemc.h"
#include "bch_ctrl_if.h"
#include "utility.h"

using namespace std;
using namespace sc_core;
using namespace sc_dt;

enum BchEnable {
    Disable,    //!<    無効
    Enable      //!<    有効
};

enum BchDecodeStatus {
    NoError,        //!<    エラーなし
    ErrorCorrected, //!<    エラー訂正
    ErrorDetected   //!<    エラー検出
};

/**
 * @brief   共通定数
 */
template <int W = 16, int E = 2, BchEnable ExtendOn = Enable>
struct BchConstants {
    static const int    data_width      = 0;
    static const int    parity_width    = 0;
    static const int    code_width      = 0;
    static const int    syndrome_num    = 0;
};

template <int W>
struct BchResult {
    BchResult() :
        data    (0),
        status  (NoError)
    {}

    BchResult(const BchResult<W>& other) :
        data    (other.data),
        status  (other.status)
    {}

    BchResult<W>& operator =(const BchResult<W>& rhs) {
        data    = rhs.data;
        status  = rhs.status;
        return *this;
    }

    bool operator ==(const BchResult<W>& rhs) const {
        return ((data == rhs.data) && (status == rhs.status)) ? true : false;
    }

    BchResult<W>& set(const sc_uint<W>& othre_data, const BchDecodeStatus other_status) {
        data    = othre_data;
        status  = other_status;
        return *this;
    }

    sc_uint<W>      data;
    BchDecodeStatus status;
};

template <int W>
void sc_trace(sc_trace_file* tr, const BchResult<W> & input, const string& name) {
    sc_trace(tr, input.data  , name + ".data"  );
    sc_trace(tr, (int)input.status, name + ".status");
}

template <int W>
ostream& operator <<(ostream& os, const BchResult<W>& input) {
    const int       print_width     = (W + 3) / 4;
    const string    status_str[3]   = {
       "NoError",
       "ErrorCorrected",
       "ErrorDetected"
    };

    os << "0x" << hex << setw(print_width) << setfill('0') << input.data
       << "(" << status_str[input.status] << ")";

    return os;
}

template <int W = 16, int E = 2, BchEnable ExtendOn = Enable>
struct BchSyndrome {
    BchSyndrome() :
        syndrome        (0),
        error_pattern   (0)
    {}

    BchSyndrome(const BchSyndrome<W, ExtendOn>& other) :
        syndrome        (other.syndrome),
        error_pattern   (other.error_pattern)
    {}

    BchSyndrome<W, E, ExtendOn>& operator =(const BchSyndrome<W, E, ExtendOn>& rhs) {
        return set(rhs.syndrome, rhs.error_pattern);
    }

    bool operator ==(const BchSyndrome<W, E, ExtendOn>& rhs) const {
        return ((syndrome == rhs.syndrome) && (error_pattern == rhs.error_pattern)) ? true : false;
    }

    BchSyndrome<W, E, ExtendOn>& set(
        const sc_uint<BchConstants<W, E, ExtendOn>::parity_width>&   syndrome_in,
        const sc_uint<BchConstants<W, E, ExtendOn>::code_width>&     error_pattern_in
    ) {
        syndrome        = syndrome_in;
        error_pattern   = error_pattern_in;
        return *this;
    }

    sc_uint<BchConstants<W, E, ExtendOn>::parity_width> syndrome;
    sc_uint<BchConstants<W, E, ExtendOn>::code_width>   error_pattern;
};

template <int W, int E, BchEnable ExtendOn>
ostream& operator <<(ostream& os, const BchSyndrome<W, E, ExtendOn>& input) {
    const int   syndrome_print_width        = (BchConstants<W, E, ExtendOn>::parity_width + 3) / 4;
    const int   error_pattern_print_width   = (BchConstants<W, E, ExtendOn>::code_width   + 3) / 4;

    os << "syndrome : 0x"      << hex << setw(syndrome_print_width)      << internal << setfill('0') << input.syndrome << " "
       << "error pattern : 0x" << hex << setw(error_pattern_print_width) << internal << setfill('0') << input.error_pattern;

    return os;
}

#define BchTypeDefine(W, E, EXTEND_ON)\
    typedef BchConstants<W, E, EXTEND_ON>       constants;\
\
    typedef sc_uint<constants::data_width>      data_t;\
    typedef sc_uint<constants::parity_width>    parity_t;\
    typedef sc_uint<constants::code_width>      code_t;\
    typedef BchResult<constants::data_width>    result_t;\
    typedef BchSyndrome<W, E, EXTEND_ON>        syndrome_t;\
    typedef BchDecodeStatus                     status_t;\
    typedef BchEnable                           enable_t;\
\
    typedef sc_fifo_in_if<data_t>               data_in_if_t;\
    typedef sc_fifo_out_if<data_t>              data_out_if_t;\
    typedef sc_fifo_in_if<code_t>               code_in_if_t;\
    typedef sc_fifo_out_if<code_t>              code_out_if_t;\
    typedef sc_fifo_in_if<result_t>             result_in_if_t;\
    typedef sc_fifo_out_if<result_t>            result_out_if_t;\
    typedef BchCtrlIf                           ctrl_if_t;

#endif /* BCH_TYPE_H_ */
