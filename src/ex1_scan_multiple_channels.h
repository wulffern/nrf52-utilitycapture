//====================================================================
//        Copyright (c) 2016 Carsten Wulff Software, Norway 
// ===================================================================
// Created       : wulff at 2016-7-7
// ===================================================================
// The MIT License (MIT)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// 
//====================================================================


#ifndef EXAMPLE1_H
#define EXAMPLE1_H

#include <stdint.h>
#include <string.h>
#include "nordic_common.h"
#include "nrf.h"

#define EX1_COUNT 5

float ex1_result_f[EX1_COUNT];
int16_t ex1_result[EX1_COUNT];

// factor = RESOLUTION/(VREF x GAIN)/2^MODE[DIFF,SE]
static const float ex1_factor[EX1_COUNT] = { 16384.0/3.0 ,
								 16384.0/2.4/2 ,
								 16384.0/3.0/2 ,
								 16384.0/3.0/2 ,
								 16384.0/3.0/2};


void ex1_saadc_init();
float * ex1_postprocess(uint16_t * count);

#endif
