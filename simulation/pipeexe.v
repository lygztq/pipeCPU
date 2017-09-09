module pipeexe(ealuc,ealuimm,ea,eb,eimm,eshift,ern0,epc4,ejal,ern,ealu);
	input [3:0] ealuc;
	input [31:0] ea,eb,eimm,epc4;
	input [4:0] ern0;
	input ealuimm,eshift,ejal;
	output [31:0] ealu;
	output [4:0] ern;
	
	wire [31:0] opa,opb,mid_ealu,epc4p4;
	
	assign ern = ern0 | {5{ejal}};
	
	add4 ad4(epc4,epc4p4);
	mux2x32 muxa(ea,eimm,eshift,opa);
	mux2x32 muxb(eb,eimm,ealuimm,opb);
	mux2x32 judge_ealu(mid_ealu,epc4p4,ejal,ealu);
	alu pipe_alu(opa,opb,ealuc,mid_ealu);
	
endmodule

module add4(x,y);
	input [31:0] x;
	output [31:0] y;
	assign y = x + 4;
endmodule
