module pipemem( mwmem,address,datain,clock,ram_clock,mmo,input_port1,input_port2,output_port);
	input mwmem,clock,ram_clock;
	input [3:0] input_port1,input_port2;
	input [31:0] address,datain;//mb 就是datamem的datain,sw指令使用,malu为address
	output [31:0] mmo;
	output [4:0] output_port;
	
	wire [31:0] io_data_out,memDataOut;
	wire output_we,mem_we;
	
	assign output_we = address[7] & mwmem;
	assign mem_we = ~address[7] & mwmem;
	
	io_in inputPort(address,io_data_out,input_port1,input_port2,ram_clock);
	io_out outputPort(address,output_we,ram_clock,datain,output_port);
	mux2x32 mem_io_mux(memDataOut,io_data_out,address[7],mmo);
	lpm_ram_dq_dram dram(address[6:2],ram_clock,datain,mem_we,memDataOut);
	//lpm_ram_dq_dram  dram(addr[6:2],dmem_clk,datain,memwe,memDataOut);

endmodule

module io_in(addr,io_data_out,in_port1,in_port2,dmem_clk);
	input [31:0] addr;
	input dmem_clk;
	input [3:0] in_port1,in_port2;
	output [31:0] io_data_out;
	
	reg [31:0] mid;
	assign io_data_out = mid;
	
	
	always @ (posedge dmem_clk)
	begin
		case(addr[3:2])
			2'b11:mid = {28'h0000000,in_port1};
			2'b10:mid = {28'h0000000,in_port2};
		endcase
	end
	
endmodule

module io_out(addr,out_port_write_enable,dmem_clk,data_in,out_port);
	input [31:0] addr;
	input out_port_write_enable;
	input dmem_clk;
	input [31:0] data_in;
	output [4:0] out_port;
	
	reg [4:0] mid;
	assign out_port = mid;
	//integer flag = 0;
	
	always @ (posedge dmem_clk)
	begin
		if(out_port_write_enable && addr[6:2]==5'b11101)
			mid = data_in[4:0];
	end
	
endmodule
