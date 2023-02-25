/**
 *  @file   bch_common_function.vh
 *  @brief  共通関数
 *
 *  @par    Copyright:
 *  (C) 2012 Taichi Ishitani All Rights Reserved.
 *
 *  @author Taichi Ishitani
 *
 *  @date   0.0.00  2012/03/31  T. Ishitani     coding start
 */

function integer get_parity_width (
    input   integer     width,
    input   integer     error_num,
    input               extend_on
);
    if ((width == 16) && (error_num == 2)) begin
        get_parity_width    = 10 + ((extend_on) ? 1 : 0);
    end
    else if ((width == 32) && (error_num == 2)) begin
        get_parity_width    = 12 + ((extend_on) ? 1 : 0);
    end
    else if ((width == 16) && (error_num == 1)) begin
        get_parity_width    = 5 + ((extend_on) ? 1 : 0);
    end
    else if ((width == 32) && (error_num == 1)) begin
        get_parity_width    = 6 + ((extend_on) ? 1 : 0);
    end
    else begin
        get_parity_width    = 0;
    end
endfunction

function integer get_code_width (
    input   integer     width,
    input   integer     error_num,
    input               extend_on
);
    get_code_width  = width + get_parity_width(width, error_num, extend_on);
endfunction

function integer calc_combination (
    input   integer     n,
    input   integer     m
);
    integer i;

    for (i = 1;i <= m;i = i + 1) begin
        calc_combination    = ((i == 1) ? 1 : calc_combination) * (n - i + 1) / i;
    end
endfunction

function integer calc_pattern_num (
    input   integer     w,
    input   integer     e
);
    integer i;

    for (i = 1;i <= e;i = i + 1) begin
        calc_pattern_num    = ((i == 1) ? 0 : calc_pattern_num) + calc_combination(w, i);
    end
endfunction
