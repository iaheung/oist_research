`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ian Heung
// 
// Create Date: 07/24/2016 
// Module Name: lowp3_2 
// Project Name: Red Pitaya Low Pass 3V IIR Filter
//////////////////////////////////////////////////////////////////////////////////

module lowp3_2(
    signal_in,
    signal_out,
    clock_in,
    reset,
    enable
);

    // Inputs
    input enable;                         // Enable signal
    input signed [27:0] signal_in;        // Input signal X[n]
    input clock_in;                       // Input clock signal
    input reset;                          // Resets the filter when high

    // Outputs
    output reg signed [27:0] signal_out;  // Output signal Y[n]

    // Constants
    parameter N = 1024;
    parameter N2 = log2(N) - 1;
    parameter down_sample = 1;            // Down-sampling factor
    parameter N_down_sample = 4;
    parameter N2_down_sample = log2(N_down_sample) - 1;

    // Internal signals and registers
    reg signed [27:0] signal_in_1;
    reg [N2_down_sample:0] down_sample_clk;
    reg [N2:0] count;
    reg signed [28+N2-1:0] signal_out_tmp;

    // Function to compute logarithm base 2
    function integer log2(input integer v);
        begin
            log2 = 0;
            while(v >> log2) 
                log2 = log2 + 1;
        end
    endfunction

    // Process for down-sampling and storing input signal
    always @(posedge clock_in) begin
        if (reset) begin
            signal_in_1 <= 0;
            down_sample_clk <= 0;
        end else if (enable) begin
            if (down_sample_clk < N_down_sample) begin
                down_sample_clk <= down_sample_clk + 1'b1;			
            end else begin
                signal_in_1 <= signal_in;
                down_sample_clk <= 0;
            end
        end
    end

    // Process for accumulating the signal and generating the output
    always @(posedge clock_in) begin
        if (reset) begin
            signal_out_tmp <= 0;
            count <= 0;
            signal_out <= 0;
        end else if (down_sample_clk == N_down_sample) begin
            if (count < N) begin
                count <= count + 1'b1;
                signal_out_tmp <= signal_out_tmp + signal_in;
            end else begin
                count <= 0;
                signal_out <= signal_out_tmp[27+N2:N2];
                signal_out_tmp <= 0;
            end
        end
    end

endmodule
