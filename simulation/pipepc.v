module pipepc(npc,wpcir,clock,resetn,pc);
	input [31:0] npc;
	input wpcir,clock,resetn;
	output [31:0] pc;
	reg [31:0] pc;
	
	wire mid_clock;
	assign mid_clock = clock & (~wpcir);
	
	always @ (negedge resetn or posedge mid_clock)
	begin
			if(resetn==0) begin
				pc <= -4;
			end else begin
				pc <= npc;
			end
	end
endmodule


module dff32 (d,clk,clrn,q);
   input  [31:0] d;
   input         clk,clrn;
   output [31:0] q;
   reg [31:0]    q;
   always @ (negedge clrn or posedge clk)
      if (clrn == 0) begin

          // q <=0;
          q <= -4;
      end else begin
          q <= d;
      end
endmodule