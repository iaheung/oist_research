`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ian Heung
// 
// Create Date: 08/11/2023
// Module Name: filterfir
// Project Name: Red Pitaya MATLAB First Order FIR Filter Testbench
//////////////////////////////////////////////////////////////////////////////////

module tst;

    // Inputs
    reg clk;
    reg rst;
    reg [7:0] x;

    // Outputs
    wire [9:0] dataout;

    // Instantiate the Unit Under Test (UUT)
    filterfir uut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .dataout(dataout)
    );

    // Clock generation
    always begin 
        #50 clk = ~clk; 
    end

    // Test sequence initialization
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 0;
        x = 0;
        #100;             // Wait for 100 time units

        // Apply reset
        rst = 1;
        #100;             // Hold reset for 100 time units

        // Release reset and apply test data
        rst = 0;
        x = 8'd5;         // Apply data value 5
        #100;

        x = 8'd10;        // Apply data value 10
        #100;

        x = 8'd12;        // Apply data value 12
        #100;

        x = 8'd15;        // Apply data value 15
        #100;

        x = 8'd16;        // Apply data value 16
        #100;
    end

endmodule
