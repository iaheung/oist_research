`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:57:28 11/23/2016 
// Design Name: 
// Module Name:    lowp2 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module lowp3_2(signal_in,signal_out, clock_in,reset,enable);

input enable;// enable
input   signed  [27:0]  signal_in;// X[n]
output  reg signed  [27:0]  signal_out;//Y[n]
input   clock_in;  //Input clock
input   reset;          //reset filter on reset high.
integer z;

function integer log2(input integer v); begin log2=0; while(v>>log2) log2=log2+1; end endfunction// This function calcualtes the logarithm of the input
parameter N=1024;
parameter N2=log2(N)-1;
parameter down_sample=1;
reg signed[27:0] signal_in_1; 
parameter N_down_sample=4;
parameter N2_down_sample=log2(N_down_sample)-1;
reg[N2_down_sample:0] down_sample_clk;

reg[N2:0] count;
reg signed [28+N2-1:0]  signal_out_tmp;

always@(posedge clock_in)
begin
	if(reset)
	begin
		signal_in_1<=0;
		down_sample_clk<=0;
	end
	else
	begin
		if(enable)
		begin
			if(down_sample_clk<N_down_sample)
			begin
				down_sample_clk<=down_sample_clk+1'b1;			
			end
			else
			begin
				signal_in_1<=signal_in;
				down_sample_clk<=0;
			end
		end
	end
end

always@(posedge clock_in)
begin
	if(reset)
	begin
		signal_out_tmp<=0;
		count<=0;
		signal_out<=0;
	end
	else
	begin
		if(down_sample_clk==N_down_sample)
		begin
			if(count<N)
			begin
				count<=count+1'b1;
				signal_out_tmp<=signal_out_tmp+signal_in;
			end
			else
			begin
				count<=0;
				signal_out<=signal_out_tmp[27+N2:N2];
				signal_out_tmp<=0;
			end
		end
	end
end



endmodule
