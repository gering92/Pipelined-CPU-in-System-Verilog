module mux4_1(out, in, sel);


	input logic [3:0] in;
	
	input logic [1:0] sel;
	
	output logic out;
	
	wire im0, im1;
	
	mux2_1 mux0(.out(im0), .i0(in[0]), .i1(in[1]), .sel(sel[0]));
	mux2_1 mux1(.out(im1), .i0(in[2]), .i1(in[3]), .sel(sel[0]));
	
	mux2_1 mux2(.out(out), .i0(im0), .i1(im1), .sel(sel[1]));

endmodule
