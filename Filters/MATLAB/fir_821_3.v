// -------------------------------------------------------------
//
// Module: fir_821_3
// Generated by MATLAB(R) 9.14 and Filter Design HDL Coder 3.1.13.
// Generated on: 2023-08-21 17:34:41
// -------------------------------------------------------------

// -------------------------------------------------------------
// HDL Code Generation Options:
//
// FIRAdderStyle: tree
// AddPipelineRegisters: on
// Name: fir_821_3
// TargetLanguage: Verilog
// TestBenchName: fir_821_3_tb
// TestBenchStimulus: impulse step ramp chirp noise 
// GenerateHDLTestBench: off

// -------------------------------------------------------------
// HDL Implementation    : Fully parallel
// Folding Factor        : 1
// -------------------------------------------------------------
// Filter Settings:
//
// Discrete-Time FIR Filter (real)
// -------------------------------
// Filter Structure  : Direct-Form FIR
// Filter Length     : 21
// Stable            : Yes
// Linear Phase      : Yes (Type 1)
// Arithmetic        : fixed
// Numerator         : s14,13 -> [-1 1)
// Input             : s14,13 -> [-1 1)
// Filter Internals  : Specify Precision
//   Output          : s14,13 -> [-1 1)
//   Product         : s14,13 -> [-1 1)
//   Accumulator     : s14,13 -> [-1 1)
//   Round Mode      : floor
//   Overflow Mode   : wrap
// -------------------------------------------------------------




`timescale 1 ns / 1 ns

module fir_821_3
               (
                clk,
                clk_enable,
                reset,
                filter_in,
                filter_out
                );

  input   clk; 
  input   clk_enable; 
  input   reset; 
  input   signed [13:0] filter_in; //sfix14_En13
  output  signed [13:0] filter_out; //sfix14_En13

////////////////////////////////////////////////////////////////
//Module Architecture: fir_821_3
////////////////////////////////////////////////////////////////
  // Local Functions
  // Type Definitions
  // Constants
  parameter signed [13:0] coeff1 = 14'b00000000010100; //sfix14_En13
  parameter signed [13:0] coeff2 = 14'b00000001011010; //sfix14_En13
  parameter signed [13:0] coeff3 = 14'b11111101111011; //sfix14_En13
  parameter signed [13:0] coeff4 = 14'b00000000111110; //sfix14_En13
  parameter signed [13:0] coeff5 = 14'b00000010100000; //sfix14_En13
  parameter signed [13:0] coeff6 = 14'b11111010000011; //sfix14_En13
  parameter signed [13:0] coeff7 = 14'b00000100111100; //sfix14_En13
  parameter signed [13:0] coeff8 = 14'b00000011101111; //sfix14_En13
  parameter signed [13:0] coeff9 = 14'b11101101100011; //sfix14_En13
  parameter signed [13:0] coeff10 = 14'b00100000100101; //sfix14_En13
  parameter signed [13:0] coeff11 = 14'b01011001100101; //sfix14_En13
  parameter signed [13:0] coeff12 = 14'b00100000100101; //sfix14_En13
  parameter signed [13:0] coeff13 = 14'b11101101100011; //sfix14_En13
  parameter signed [13:0] coeff14 = 14'b00000011101111; //sfix14_En13
  parameter signed [13:0] coeff15 = 14'b00000100111100; //sfix14_En13
  parameter signed [13:0] coeff16 = 14'b11111010000011; //sfix14_En13
  parameter signed [13:0] coeff17 = 14'b00000010100000; //sfix14_En13
  parameter signed [13:0] coeff18 = 14'b00000000111110; //sfix14_En13
  parameter signed [13:0] coeff19 = 14'b11111101111011; //sfix14_En13
  parameter signed [13:0] coeff20 = 14'b00000001011010; //sfix14_En13
  parameter signed [13:0] coeff21 = 14'b00000000010100; //sfix14_En13

  // Signals
  reg  signed [13:0] delay_pipeline [0:20] ; // sfix14_En13
  wire signed [13:0] product21; // sfix14_En13
  wire signed [27:0] mul_temp; // sfix28_En26
  wire signed [13:0] product20; // sfix14_En13
  wire signed [27:0] mul_temp_1; // sfix28_En26
  wire signed [13:0] product19; // sfix14_En13
  wire signed [27:0] mul_temp_2; // sfix28_En26
  wire signed [13:0] product18; // sfix14_En13
  wire signed [27:0] mul_temp_3; // sfix28_En26
  wire signed [13:0] product17; // sfix14_En13
  wire signed [27:0] mul_temp_4; // sfix28_En26
  wire signed [13:0] product16; // sfix14_En13
  wire signed [27:0] mul_temp_5; // sfix28_En26
  wire signed [13:0] product15; // sfix14_En13
  wire signed [27:0] mul_temp_6; // sfix28_En26
  wire signed [13:0] product14; // sfix14_En13
  wire signed [27:0] mul_temp_7; // sfix28_En26
  wire signed [13:0] product13; // sfix14_En13
  wire signed [27:0] mul_temp_8; // sfix28_En26
  wire signed [13:0] product12; // sfix14_En13
  wire signed [27:0] mul_temp_9; // sfix28_En26
  wire signed [13:0] product11; // sfix14_En13
  wire signed [27:0] mul_temp_10; // sfix28_En26
  wire signed [13:0] product10; // sfix14_En13
  wire signed [27:0] mul_temp_11; // sfix28_En26
  wire signed [13:0] product9; // sfix14_En13
  wire signed [27:0] mul_temp_12; // sfix28_En26
  wire signed [13:0] product8; // sfix14_En13
  wire signed [27:0] mul_temp_13; // sfix28_En26
  wire signed [13:0] product7; // sfix14_En13
  wire signed [27:0] mul_temp_14; // sfix28_En26
  wire signed [13:0] product6; // sfix14_En13
  wire signed [27:0] mul_temp_15; // sfix28_En26
  wire signed [13:0] product5; // sfix14_En13
  wire signed [27:0] mul_temp_16; // sfix28_En26
  wire signed [13:0] product4; // sfix14_En13
  wire signed [27:0] mul_temp_17; // sfix28_En26
  wire signed [13:0] product3; // sfix14_En13
  wire signed [27:0] mul_temp_18; // sfix28_En26
  wire signed [13:0] product2; // sfix14_En13
  wire signed [27:0] mul_temp_19; // sfix28_En26
  wire signed [13:0] product1; // sfix14_En13
  wire signed [27:0] mul_temp_20; // sfix28_En26
  wire signed [13:0] sum_final; // sfix14_En13
  wire signed [13:0] sum1_1; // sfix14_En13
  wire signed [13:0] add_signext; // sfix14_En13
  wire signed [13:0] add_signext_1; // sfix14_En13
  wire signed [14:0] add_temp; // sfix15_En13
  reg  signed [13:0] sumpipe1_1; // sfix14_En13
  wire signed [13:0] sum1_2; // sfix14_En13
  wire signed [13:0] add_signext_2; // sfix14_En13
  wire signed [13:0] add_signext_3; // sfix14_En13
  wire signed [14:0] add_temp_1; // sfix15_En13
  reg  signed [13:0] sumpipe1_2; // sfix14_En13
  wire signed [13:0] sum1_3; // sfix14_En13
  wire signed [13:0] add_signext_4; // sfix14_En13
  wire signed [13:0] add_signext_5; // sfix14_En13
  wire signed [14:0] add_temp_2; // sfix15_En13
  reg  signed [13:0] sumpipe1_3; // sfix14_En13
  wire signed [13:0] sum1_4; // sfix14_En13
  wire signed [13:0] add_signext_6; // sfix14_En13
  wire signed [13:0] add_signext_7; // sfix14_En13
  wire signed [14:0] add_temp_3; // sfix15_En13
  reg  signed [13:0] sumpipe1_4; // sfix14_En13
  wire signed [13:0] sum1_5; // sfix14_En13
  wire signed [13:0] add_signext_8; // sfix14_En13
  wire signed [13:0] add_signext_9; // sfix14_En13
  wire signed [14:0] add_temp_4; // sfix15_En13
  reg  signed [13:0] sumpipe1_5; // sfix14_En13
  wire signed [13:0] sum1_6; // sfix14_En13
  wire signed [13:0] add_signext_10; // sfix14_En13
  wire signed [13:0] add_signext_11; // sfix14_En13
  wire signed [14:0] add_temp_5; // sfix15_En13
  reg  signed [13:0] sumpipe1_6; // sfix14_En13
  wire signed [13:0] sum1_7; // sfix14_En13
  wire signed [13:0] add_signext_12; // sfix14_En13
  wire signed [13:0] add_signext_13; // sfix14_En13
  wire signed [14:0] add_temp_6; // sfix15_En13
  reg  signed [13:0] sumpipe1_7; // sfix14_En13
  wire signed [13:0] sum1_8; // sfix14_En13
  wire signed [13:0] add_signext_14; // sfix14_En13
  wire signed [13:0] add_signext_15; // sfix14_En13
  wire signed [14:0] add_temp_7; // sfix15_En13
  reg  signed [13:0] sumpipe1_8; // sfix14_En13
  wire signed [13:0] sum1_9; // sfix14_En13
  wire signed [13:0] add_signext_16; // sfix14_En13
  wire signed [13:0] add_signext_17; // sfix14_En13
  wire signed [14:0] add_temp_8; // sfix15_En13
  reg  signed [13:0] sumpipe1_9; // sfix14_En13
  wire signed [13:0] sum1_10; // sfix14_En13
  wire signed [13:0] add_signext_18; // sfix14_En13
  wire signed [13:0] add_signext_19; // sfix14_En13
  wire signed [14:0] add_temp_9; // sfix15_En13
  reg  signed [13:0] sumpipe1_10; // sfix14_En13
  reg  signed [13:0] sumpipe1_11; // sfix14_En13
  wire signed [13:0] sum2_1; // sfix14_En13
  wire signed [13:0] add_signext_20; // sfix14_En13
  wire signed [13:0] add_signext_21; // sfix14_En13
  wire signed [14:0] add_temp_10; // sfix15_En13
  reg  signed [13:0] sumpipe2_1; // sfix14_En13
  wire signed [13:0] sum2_2; // sfix14_En13
  wire signed [13:0] add_signext_22; // sfix14_En13
  wire signed [13:0] add_signext_23; // sfix14_En13
  wire signed [14:0] add_temp_11; // sfix15_En13
  reg  signed [13:0] sumpipe2_2; // sfix14_En13
  wire signed [13:0] sum2_3; // sfix14_En13
  wire signed [13:0] add_signext_24; // sfix14_En13
  wire signed [13:0] add_signext_25; // sfix14_En13
  wire signed [14:0] add_temp_12; // sfix15_En13
  reg  signed [13:0] sumpipe2_3; // sfix14_En13
  wire signed [13:0] sum2_4; // sfix14_En13
  wire signed [13:0] add_signext_26; // sfix14_En13
  wire signed [13:0] add_signext_27; // sfix14_En13
  wire signed [14:0] add_temp_13; // sfix15_En13
  reg  signed [13:0] sumpipe2_4; // sfix14_En13
  wire signed [13:0] sum2_5; // sfix14_En13
  wire signed [13:0] add_signext_28; // sfix14_En13
  wire signed [13:0] add_signext_29; // sfix14_En13
  wire signed [14:0] add_temp_14; // sfix15_En13
  reg  signed [13:0] sumpipe2_5; // sfix14_En13
  reg  signed [13:0] sumpipe2_6; // sfix14_En13
  wire signed [13:0] sum3_1; // sfix14_En13
  wire signed [13:0] add_signext_30; // sfix14_En13
  wire signed [13:0] add_signext_31; // sfix14_En13
  wire signed [14:0] add_temp_15; // sfix15_En13
  reg  signed [13:0] sumpipe3_1; // sfix14_En13
  wire signed [13:0] sum3_2; // sfix14_En13
  wire signed [13:0] add_signext_32; // sfix14_En13
  wire signed [13:0] add_signext_33; // sfix14_En13
  wire signed [14:0] add_temp_16; // sfix15_En13
  reg  signed [13:0] sumpipe3_2; // sfix14_En13
  wire signed [13:0] sum3_3; // sfix14_En13
  wire signed [13:0] add_signext_34; // sfix14_En13
  wire signed [13:0] add_signext_35; // sfix14_En13
  wire signed [14:0] add_temp_17; // sfix15_En13
  reg  signed [13:0] sumpipe3_3; // sfix14_En13
  wire signed [13:0] sum4_1; // sfix14_En13
  wire signed [13:0] add_signext_36; // sfix14_En13
  wire signed [13:0] add_signext_37; // sfix14_En13
  wire signed [14:0] add_temp_18; // sfix15_En13
  reg  signed [13:0] sumpipe4_1; // sfix14_En13
  reg  signed [13:0] sumpipe4_2; // sfix14_En13
  wire signed [13:0] sum5_1; // sfix14_En13
  wire signed [13:0] add_signext_38; // sfix14_En13
  wire signed [13:0] add_signext_39; // sfix14_En13
  wire signed [14:0] add_temp_19; // sfix15_En13
  reg  signed [13:0] sumpipe5_1; // sfix14_En13
  reg  signed [13:0] output_register; // sfix14_En13

  // Block Statements
  always @( posedge clk or posedge reset)
    begin: Delay_Pipeline_process
      if (reset == 1'b1) begin
        delay_pipeline[0] <= 0;
        delay_pipeline[1] <= 0;
        delay_pipeline[2] <= 0;
        delay_pipeline[3] <= 0;
        delay_pipeline[4] <= 0;
        delay_pipeline[5] <= 0;
        delay_pipeline[6] <= 0;
        delay_pipeline[7] <= 0;
        delay_pipeline[8] <= 0;
        delay_pipeline[9] <= 0;
        delay_pipeline[10] <= 0;
        delay_pipeline[11] <= 0;
        delay_pipeline[12] <= 0;
        delay_pipeline[13] <= 0;
        delay_pipeline[14] <= 0;
        delay_pipeline[15] <= 0;
        delay_pipeline[16] <= 0;
        delay_pipeline[17] <= 0;
        delay_pipeline[18] <= 0;
        delay_pipeline[19] <= 0;
        delay_pipeline[20] <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          delay_pipeline[0] <= filter_in;
          delay_pipeline[1] <= delay_pipeline[0];
          delay_pipeline[2] <= delay_pipeline[1];
          delay_pipeline[3] <= delay_pipeline[2];
          delay_pipeline[4] <= delay_pipeline[3];
          delay_pipeline[5] <= delay_pipeline[4];
          delay_pipeline[6] <= delay_pipeline[5];
          delay_pipeline[7] <= delay_pipeline[6];
          delay_pipeline[8] <= delay_pipeline[7];
          delay_pipeline[9] <= delay_pipeline[8];
          delay_pipeline[10] <= delay_pipeline[9];
          delay_pipeline[11] <= delay_pipeline[10];
          delay_pipeline[12] <= delay_pipeline[11];
          delay_pipeline[13] <= delay_pipeline[12];
          delay_pipeline[14] <= delay_pipeline[13];
          delay_pipeline[15] <= delay_pipeline[14];
          delay_pipeline[16] <= delay_pipeline[15];
          delay_pipeline[17] <= delay_pipeline[16];
          delay_pipeline[18] <= delay_pipeline[17];
          delay_pipeline[19] <= delay_pipeline[18];
          delay_pipeline[20] <= delay_pipeline[19];
        end
      end
    end // Delay_Pipeline_process


  assign mul_temp = delay_pipeline[20] * coeff21;
  assign product21 = mul_temp[26:13];

  assign mul_temp_1 = delay_pipeline[19] * coeff20;
  assign product20 = mul_temp_1[26:13];

  assign mul_temp_2 = delay_pipeline[18] * coeff19;
  assign product19 = mul_temp_2[26:13];

  assign mul_temp_3 = delay_pipeline[17] * coeff18;
  assign product18 = mul_temp_3[26:13];

  assign mul_temp_4 = delay_pipeline[16] * coeff17;
  assign product17 = mul_temp_4[26:13];

  assign mul_temp_5 = delay_pipeline[15] * coeff16;
  assign product16 = mul_temp_5[26:13];

  assign mul_temp_6 = delay_pipeline[14] * coeff15;
  assign product15 = mul_temp_6[26:13];

  assign mul_temp_7 = delay_pipeline[13] * coeff14;
  assign product14 = mul_temp_7[26:13];

  assign mul_temp_8 = delay_pipeline[12] * coeff13;
  assign product13 = mul_temp_8[26:13];

  assign mul_temp_9 = delay_pipeline[11] * coeff12;
  assign product12 = mul_temp_9[26:13];

  assign mul_temp_10 = delay_pipeline[10] * coeff11;
  assign product11 = mul_temp_10[26:13];

  assign mul_temp_11 = delay_pipeline[9] * coeff10;
  assign product10 = mul_temp_11[26:13];

  assign mul_temp_12 = delay_pipeline[8] * coeff9;
  assign product9 = mul_temp_12[26:13];

  assign mul_temp_13 = delay_pipeline[7] * coeff8;
  assign product8 = mul_temp_13[26:13];

  assign mul_temp_14 = delay_pipeline[6] * coeff7;
  assign product7 = mul_temp_14[26:13];

  assign mul_temp_15 = delay_pipeline[5] * coeff6;
  assign product6 = mul_temp_15[26:13];

  assign mul_temp_16 = delay_pipeline[4] * coeff5;
  assign product5 = mul_temp_16[26:13];

  assign mul_temp_17 = delay_pipeline[3] * coeff4;
  assign product4 = mul_temp_17[26:13];

  assign mul_temp_18 = delay_pipeline[2] * coeff3;
  assign product3 = mul_temp_18[26:13];

  assign mul_temp_19 = delay_pipeline[1] * coeff2;
  assign product2 = mul_temp_19[26:13];

  assign mul_temp_20 = delay_pipeline[0] * coeff1;
  assign product1 = mul_temp_20[26:13];

  assign add_signext = product21;
  assign add_signext_1 = product20;
  assign add_temp = add_signext + add_signext_1;
  assign sum1_1 = add_temp[13:0];

  assign add_signext_2 = product19;
  assign add_signext_3 = product18;
  assign add_temp_1 = add_signext_2 + add_signext_3;
  assign sum1_2 = add_temp_1[13:0];

  assign add_signext_4 = product17;
  assign add_signext_5 = product16;
  assign add_temp_2 = add_signext_4 + add_signext_5;
  assign sum1_3 = add_temp_2[13:0];

  assign add_signext_6 = product15;
  assign add_signext_7 = product14;
  assign add_temp_3 = add_signext_6 + add_signext_7;
  assign sum1_4 = add_temp_3[13:0];

  assign add_signext_8 = product13;
  assign add_signext_9 = product12;
  assign add_temp_4 = add_signext_8 + add_signext_9;
  assign sum1_5 = add_temp_4[13:0];

  assign add_signext_10 = product11;
  assign add_signext_11 = product10;
  assign add_temp_5 = add_signext_10 + add_signext_11;
  assign sum1_6 = add_temp_5[13:0];

  assign add_signext_12 = product9;
  assign add_signext_13 = product8;
  assign add_temp_6 = add_signext_12 + add_signext_13;
  assign sum1_7 = add_temp_6[13:0];

  assign add_signext_14 = product7;
  assign add_signext_15 = product6;
  assign add_temp_7 = add_signext_14 + add_signext_15;
  assign sum1_8 = add_temp_7[13:0];

  assign add_signext_16 = product5;
  assign add_signext_17 = product4;
  assign add_temp_8 = add_signext_16 + add_signext_17;
  assign sum1_9 = add_temp_8[13:0];

  assign add_signext_18 = product3;
  assign add_signext_19 = product2;
  assign add_temp_9 = add_signext_18 + add_signext_19;
  assign sum1_10 = add_temp_9[13:0];

  always @ (posedge clk or posedge reset)
    begin: temp_process1
      if (reset == 1'b1) begin
        sumpipe1_1 <= 0;
        sumpipe1_2 <= 0;
        sumpipe1_3 <= 0;
        sumpipe1_4 <= 0;
        sumpipe1_5 <= 0;
        sumpipe1_6 <= 0;
        sumpipe1_7 <= 0;
        sumpipe1_8 <= 0;
        sumpipe1_9 <= 0;
        sumpipe1_10 <= 0;
        sumpipe1_11 <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          sumpipe1_1 <= sum1_1;
          sumpipe1_2 <= sum1_2;
          sumpipe1_3 <= sum1_3;
          sumpipe1_4 <= sum1_4;
          sumpipe1_5 <= sum1_5;
          sumpipe1_6 <= sum1_6;
          sumpipe1_7 <= sum1_7;
          sumpipe1_8 <= sum1_8;
          sumpipe1_9 <= sum1_9;
          sumpipe1_10 <= sum1_10;
          sumpipe1_11 <= product1;
        end
      end
    end // temp_process1

  assign add_signext_20 = sumpipe1_1;
  assign add_signext_21 = sumpipe1_2;
  assign add_temp_10 = add_signext_20 + add_signext_21;
  assign sum2_1 = add_temp_10[13:0];

  assign add_signext_22 = sumpipe1_3;
  assign add_signext_23 = sumpipe1_4;
  assign add_temp_11 = add_signext_22 + add_signext_23;
  assign sum2_2 = add_temp_11[13:0];

  assign add_signext_24 = sumpipe1_5;
  assign add_signext_25 = sumpipe1_6;
  assign add_temp_12 = add_signext_24 + add_signext_25;
  assign sum2_3 = add_temp_12[13:0];

  assign add_signext_26 = sumpipe1_7;
  assign add_signext_27 = sumpipe1_8;
  assign add_temp_13 = add_signext_26 + add_signext_27;
  assign sum2_4 = add_temp_13[13:0];

  assign add_signext_28 = sumpipe1_9;
  assign add_signext_29 = sumpipe1_10;
  assign add_temp_14 = add_signext_28 + add_signext_29;
  assign sum2_5 = add_temp_14[13:0];

  always @ (posedge clk or posedge reset)
    begin: temp_process2
      if (reset == 1'b1) begin
        sumpipe2_1 <= 0;
        sumpipe2_2 <= 0;
        sumpipe2_3 <= 0;
        sumpipe2_4 <= 0;
        sumpipe2_5 <= 0;
        sumpipe2_6 <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          sumpipe2_1 <= sum2_1;
          sumpipe2_2 <= sum2_2;
          sumpipe2_3 <= sum2_3;
          sumpipe2_4 <= sum2_4;
          sumpipe2_5 <= sum2_5;
          sumpipe2_6 <= sumpipe1_11;
        end
      end
    end // temp_process2

  assign add_signext_30 = sumpipe2_1;
  assign add_signext_31 = sumpipe2_2;
  assign add_temp_15 = add_signext_30 + add_signext_31;
  assign sum3_1 = add_temp_15[13:0];

  assign add_signext_32 = sumpipe2_3;
  assign add_signext_33 = sumpipe2_4;
  assign add_temp_16 = add_signext_32 + add_signext_33;
  assign sum3_2 = add_temp_16[13:0];

  assign add_signext_34 = sumpipe2_5;
  assign add_signext_35 = sumpipe2_6;
  assign add_temp_17 = add_signext_34 + add_signext_35;
  assign sum3_3 = add_temp_17[13:0];

  always @ (posedge clk or posedge reset)
    begin: temp_process3
      if (reset == 1'b1) begin
        sumpipe3_1 <= 0;
        sumpipe3_2 <= 0;
        sumpipe3_3 <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          sumpipe3_1 <= sum3_1;
          sumpipe3_2 <= sum3_2;
          sumpipe3_3 <= sum3_3;
        end
      end
    end // temp_process3

  assign add_signext_36 = sumpipe3_1;
  assign add_signext_37 = sumpipe3_2;
  assign add_temp_18 = add_signext_36 + add_signext_37;
  assign sum4_1 = add_temp_18[13:0];

  always @ (posedge clk or posedge reset)
    begin: temp_process4
      if (reset == 1'b1) begin
        sumpipe4_1 <= 0;
        sumpipe4_2 <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          sumpipe4_1 <= sum4_1;
          sumpipe4_2 <= sumpipe3_3;
        end
      end
    end // temp_process4

  assign add_signext_38 = sumpipe4_1;
  assign add_signext_39 = sumpipe4_2;
  assign add_temp_19 = add_signext_38 + add_signext_39;
  assign sum5_1 = add_temp_19[13:0];

  always @ (posedge clk or posedge reset)
    begin: temp_process5
      if (reset == 1'b1) begin
        sumpipe5_1 <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          sumpipe5_1 <= sum5_1;
        end
      end
    end // temp_process5

  assign sum_final = sumpipe5_1;

  always @ (posedge clk or posedge reset)
    begin: Output_Register_process
      if (reset == 1'b1) begin
        output_register <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          output_register <= sum_final;
        end
      end
    end // Output_Register_process

  // Assignment Statements
  assign filter_out = output_register;
endmodule  // fir_821_3