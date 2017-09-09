module pipeif(pcsource,pc,bpc,da,jpc,npc,pc4,ins,rom_clock/*,if_flush*/);
	input rom_clock;
	//input if_flush;
	input [1:0] pcsource;
	input [31:0] pc,bpc,da,jpc;
	output [31:0] npc,pc4,ins;
	
	//wire [31:0] mid_ins;
	wire [31:0] pc4;
	//reg [31:0] ins;


	
	adder p4(pc,pc4);
	
	
	mux4x32 nextpc(pc4,bpc,da,jpc,pcsource,npc);
	instmem instruction_mem(pc,ins,rom_clock);
	
endmodule

module foo(int,if_flush,final_ins);
	input if_flush;
	input [31:0] int;
	output [31:0] final_ins;
	
	assign final_ins = int & {32{~if_flush}};
	
endmodule

module adder(x,y);
	input [31:0] x;
	output [31:0] y;
	
	assign y = x+4;
endmodule

module instmem (addr,inst,mem_clk);
   input  [31:0] addr;
   input         mem_clk;
   output [31:0] inst;      
   
   lpm_rom_irom  irom (addr[7:2],mem_clk,inst); 
	
endmodule 