`timescale 1ps/1ps


//ALU testing 
//supports pass, add, and subtract
//nothing else should work in this module

module ALU (A, B, cntrl, result, overflow, negative, zero, carry_out);

	//64 bit inputs
	input logic [63:0] A, B;
	
	//3 bit ALU control signals
	input logic [2:0] cntrl;
	
	//64 bit result output
	output logic [63:0] result; 
	
	//output flags for ALU op results
	output logic overflow, negative, zero, carry_out;
	
	//holds all the things to shove into ALU control mux
	logic [7:0][63:0] ALU_inputs;
	
	
	//wire to determine whether to send B or ~B to the ALU
	wire [63:0] B_adj;
	
	
	//wire to send output of 64 bit adder to add and sub op selections
	wire [63:0] toALU;
	
	
	//set B into two's comp stage 1 if needed (invert bits)
	mux64x2_1 twos(.sel(cntrl[0]), .i0(B), .i1(B), .out(B_adj));
	
	
	//adder
	//when sub control = 1, sets B into two's comp stage 2 (add 1)
	//sets overflow and carry_out flags
	adder64_bit add_sub(.input1(A), .input2(B_adj), .sub_control(cntrl[0]), .out(toALU), .of_flag(overflow), .co_flag(carry_out));
	
	
	//set negative flag, 3 input AND 
	//only if interpreted as two's comp. Two's comp only used in sub ops
	//sub op: 011
	//twos comp used -> MSB of result is sign
	//negative = result[63] & cntrl[1] & cntrl[0]
	and #(50) neg_flag(negative, result[63], cntrl[1], cntrl[0]);
	
	
	//set zero flag
	zeroCheck flag(.check(result), .z_flag(zero));
	
	//pass B to ALU op selector for pass line
	assign ALU_inputs [0] = B;
	
	
	//pass output of adder to both add and subtract lines of ALU op selector
	assign ALU_inputs [2] = toALU;
	assign ALU_inputs [3] = toALU; 
	
	
	//pass dont cares to unused mux inputs
	assign ALU_inputs [1] = 64'bX;
	assign ALU_inputs [7] = 64'bX;
	
	
	//mux to select output of ALU
	mux64x8_1 ALU_opSel(.in(ALU_inputs), .out(result), .ctrl(cntrl));


endmodule
