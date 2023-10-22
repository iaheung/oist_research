`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ian Heung
// 
// Create Date: 07/23/2023
// Module Name: lowp6 
// Project Name: Red Pitaya Low Pass 6V IIR Filter
//////////////////////////////////////////////////////////////////////////////////

module lowp6(
    signal_in,
    signal_out,
    clock_in,
    reset,
    enable
);

    // Inputs
    input enable;
    input signed [27:0] signal_in;
    input clock_in;
    input reset;      // Reset the filter when reset is high.

    // Outputs
    output reg signed [27:0] signal_out;

    // Constants
    parameter N = 1024;
    
    // Function to compute logarithm base 2
    function integer log2(input integer v);
        begin
            log2 = 0;
            while(v >> log2) 
                log2 = log2 + 1;
        end
    endfunction

    // Compute the value of N2
    parameter N2 = log2(N) - 1;

    // Internal signals
    reg signed [27+N2:0] signal_out_tmp;
    reg signed [27:0] data [0:N-1];

    // Generate shift registers
    genvar i;
    generate
        for (i = 0; i < N-1; i = i + 1) begin: gd
            always @(posedge clock_in) begin
                if(reset == 1'b1) 
                    data[i+1] <= 0;
                else 
                    data[i+1] <= data[i];
            end
        end
    endgenerate

    // Load the first data register
    always @(posedge clock_in) begin
        if(reset == 1'b1)
            data[0] <= 0;
        else
            data[0] <= signal_in;
    end

    // Compute the output signal
    reg signed [27+N2:0] signal_out_tmp_3;
    wire signed [27+N2:0] signal_out_tmp_2 = signal_out_tmp_3 + signal_in - data[N-1];

    always @(posedge clock_in) begin
        signal_out <= signal_out_tmp_2[27+N2:N2];
        signal_out_tmp_3 <= signal_out_tmp_2;
    end

endmodule
