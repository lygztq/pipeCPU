module pipepc(npc,wpcir,clock,resetn,pc);
	input [31:0] npc;
	input wpcir,clock,resetn;
	output [31:0] pc;
	//reg [31:0] pc;
	
	//wire mid_clock;
	dffe32 test(npc,clock,resetn,wpcir,pc);
endmodule


module dffe32(d,clk,clrn,e,q);
   input  [31:0] d;
   input  clk,clrn,e;
   output [31:0] q;
   reg    [31:0] q;
   
   initial
   begin
     q=0;
   end
   
   always @ (negedge clrn or posedge clk)
      if (clrn == 0) begin
         q <= -4;
      end else begin
         if (e == 1) q <= d;
      end
endmodule