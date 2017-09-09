module pipeir(pc4,ins,wpcir,clock,resetn,dpc4,inst,if_flush);
	input [31:0] pc4,ins;
	input wpcir,clock,resetn,if_flush;
	output [31:0] dpc4,inst;
	
	reg [31:0] dpc4,inst;
	//wire mid_clock;
	//assign mid_clock = clock & (~wpcir);
	
	always @ (posedge clock or negedge resetn)
	begin
			if(resetn==0) 
			begin
				dpc4 <= -4;
				inst <= 0;
			end
			else if(if_flush==1)
			begin
				inst <= 0;
			end
			else if(wpcir==1) 
			begin
				dpc4 <= pc4;
				inst <= ins;
			end
	end
	
endmodule
