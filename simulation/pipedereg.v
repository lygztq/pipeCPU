module pipedereg( dwreg,dm2reg,dwmem,daluc,daluimm,da,db,dimm,drn,dshift,
							 djal,dpc4,clock,resetn,ewreg,em2reg,ewmem,ealuc,ealuimm, 
							  ea,eb,eimm,ern0,eshift,ejal,epc4);
	input clock,resetn;
	input dwreg,dm2reg,dwmem,daluimm,dshift,djal;
	input [4:0] drn;
	input [3:0] daluc;
	input [31:0] da,db,dimm,dpc4;
	output [3:0] ealuc;
	output [31:0] ea,eb,eimm,epc4;
	output [4:0] ern0;
	output ewreg,em2reg,ewmem,ealuimm,eshift,ejal;
	
	reg [3:0] ealuc;
	reg [31:0] ea,eb,eimm,epc4;
	reg [4:0] ern0;
	reg ewreg,em2reg,ewmem,ealuimm,eshift,ejal;
	
	always @ (posedge clock or negedge resetn)
	begin
		if(resetn==0) begin
			ealuc <= 0;
			ea <= 0; eb <= 0; eimm <= 0; epc4 <= 0;
			ern0 <= 0;
			ewreg <= 0; em2reg <= 0; ewmem<=0;ealuimm<=0;eshift<=0;ejal<=0;
		end else begin
			ealuc <= daluc;
			ea <= da; eb<=db; eimm<=dimm; epc4<=dpc4;
			ern0 <= drn;
			ewreg <= dwreg; em2reg <= dm2reg; ewmem <= dwmem; ealuimm <= daluimm;
			eshift <= dshift; ejal <= djal;
		end
	end
	
endmodule
