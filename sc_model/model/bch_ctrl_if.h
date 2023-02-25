/**
 *  @file   bch_ctrl_if.h
 *  @brief  BCH符号エンコーダ/デコーダ制御インターフェース
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/29  T. Ishitani     coding start
 */

#ifndef BCH_CTRL_IF_H_
#define BCH_CTRL_IF_H_

#include "systemc.h"

using namespace sc_core;
using namespace sc_dt;

/**
 * @brief   エンコーダ/デコーダ制御インターフェース
 */
struct BchCtrlIf :
    public  sc_interface
{
    virtual void set_enable()   = 0;
    virtual void set_disable()  = 0;
};


#endif /* BCH_CTRL_IF_H_ */
