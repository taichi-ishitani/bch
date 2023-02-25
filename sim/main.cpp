/**
 *  @file   main.cpp
 *  @brief
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/31  T. Ishitani     coding start
 */

#include "systemc.h"
#include "sim_top.h"

using namespace sc_core;
using namespace sc_dt;

#ifndef MAX_ERROR_NUM
#define MAX_ERROR_NUM   10
#endif

#ifndef DATA_WIDTH
#define DATA_WIDTH  16
#endif

#ifndef ERROR_NUM
#define ERROR_NUM   1
#endif

#ifndef EXTEND_ON
#define EXTEND_ON   Enable
#endif

#ifndef DATA_TYPE
#define DATA_TYPE   uint32_t
#endif

#ifndef CODE_TYPE
//#define CODE_TYPE   vluint64_t
#define CODE_TYPE   uint32_t
#endif

int sc_main(int argc, char* argv[]) {
    SimTop<DATA_WIDTH, ERROR_NUM, EXTEND_ON, DATA_TYPE, CODE_TYPE>* top;

    sc_report_handler::stop_after(SC_ERROR, MAX_ERROR_NUM);
    sc_report_handler::set_actions(SC_ERROR, SC_DISPLAY);
    sc_report_handler::set_actions(SC_FATAL, SC_DISPLAY | SC_STOP);

    top = new SimTop<DATA_WIDTH, ERROR_NUM, EXTEND_ON, DATA_TYPE, CODE_TYPE>("top");
    sc_start();
    return 0;
}
