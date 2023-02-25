/**
 *  @file   main.cpp
 *  @brief
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/28  T. Ishitani     coding start
 */

#include "model_env.h"

#ifndef MAX_ERROR_NUM
#define MAX_ERROR_NUM   10
#endif

#ifndef DATA_WIDTH
#define DATA_WIDTH  32
#endif

#ifndef ERROR_NUM
#define ERROR_NUM   1
#endif

#ifndef EXTEND_ON
#define EXTEND_ON   Enable
#endif

int sc_main(int argc, char* argv[]) {
    model_env<DATA_WIDTH, ERROR_NUM, EXTEND_ON>*    env;

    env = new model_env<DATA_WIDTH, ERROR_NUM, EXTEND_ON>("env");
    sc_start();
    return 0;
}
