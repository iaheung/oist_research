`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ian Heung
// 
// Create Date: 08/11/2023
// Module Name: filterfir
// Project Name: Red Pitaya MATLAB First Order FIR Filter
//////////////////////////////////////////////////////////////////////////////////

module firstorder_fir_1(
    clk,
    rst,
    x,
    dataout
);

    // Inputs
    input clk, rst;
    input [7:0] x;

    // Outputs
    output [9:0] dataout;

    // Internal signals
    wire [7:0] d1, d2, d3;
    wire [7:0] m1, m2, m3, m4, m5;
    wire [7:0] d11, d12, d13, d14;

    // Coefficient parameters
    parameter h0 = 3'b101;
    parameter h1 = 3'b100;
    parameter h2 = 3'b011;
    parameter h3 = 3'b010;
    parameter h4 = 3'b001;

    // Multiple input data with the filter taps
    assign m1 = x >> h0;

    // Instantiate d flip-flop
    dff u2 (.clk(clk), .rst(rst), .d(x), .q(d11));

    assign m2 = d11 >> h1;
    assign d1 = m1 + m2;

    dff u4 (.clk(clk), .rst(rst), .d(d11), .q(d12));

    assign m3 = d12 >> h2;
    assign d2 = d1 + m3;

    dff u6 (.clk(clk), .rst(rst), .d(d12), .q(d13));

    assign m4 = d13 >> h3;
    assign d3 = d2 + m4;

    dff u8 (.clk(clk), .rst(rst), .d(d13), .q(d14));

    assign m5 = d14 >> h4;
    assign dataout = d3 + m5;

endmodule

module dff(
    clk,
    rst,
    d,
    q
);

    // Inputs
    input clk, rst;
    input [7:0] d;

    // Outputs
    output [7:0] q;

    // Internal registers
    reg [7:0] q;

    // D flip-flop behavior
    always @(posedge clk) begin
        if (rst == 1) 
            q = 0;
        else 
            q = d;
    end

endmodule
