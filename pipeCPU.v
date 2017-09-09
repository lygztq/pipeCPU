module pipelined_computer(resetn,clock,mem_clock,pc,
									inst,ealu,malu,walu,input_port1,input_port2,output_port);
	input resetn,clock,mem_clock;
	input [3:0] input_port1,input_port2;
	output [4:0] output_port;
	//定义整个计算机 module 和外界交互的输入信号，包括复位信号 resetn、时钟信号 clock、 
	//以及一个和 clock 同频率但反相的 mem_clock 信号。mem_clock 用于指令同步 ROM 和 
	//数据同步 RAM 使用，其波形需要有别于实验一。 
	//这些信号可以用作仿真验证时的输出观察信号。 
	output [31:0] pc,inst,ealu,malu,walu;//用于仿真
	wire [31:0] bpc,jpc,npc,pc4,ins,inst;//IF取指令阶段
	wire [31:0] dpc4,da,db,dimm;//ID译码阶段
	wire [31:0] epc4,ea,eb,eimm;//EXE指令运行阶段
	wire [31:0] mb,mmo;//MEM访问数据阶段
	wire [31:0] wmo,wdi;//WB回写寄存器阶段
	wire [4:0] drn,ern0,ern,mrn,wrn;//模块间互连，通过流水线寄存器传递结果寄存器号的信号线，寄存器号（32个寄存器）为5bit
	wire [3:0] daluc,ealuc;//ID阶段向IF阶段模块传递的aluc控制信号,4bit
	wire [1:0] pcsource;//CU模块向IF阶段传递的PC选择信号，2bit
	wire wpcir;//CU模块发出的控制流水线停顿的控制信号，使PC和IF/ID流水线寄存器保持不变,(高电平有效？)
	wire dwreg,dm2reg,dwmem,daluimm,dshift,djal; //ID阶段产生，需要向后传递的信号
	wire ewreg,em2reg,ewmem,ealuimm,eshift,ejal; //来自于ID/EXE流水线寄存器，EXE阶段使用或向后传递的信号
	wire mwreg,mm2reg,mwmem;//来自于EXE/MEM流水线寄存器，MEM阶段使用，或需要向后传递的信号
	wire wwreg,wm2reg; //来自于MEM/WB流水线寄存器，WB阶段使用的信号
	wire if_flush;
	
	pipepc prog_cnt(npc,wpcir,clock,resetn,pc); //finished
	//程序计数模块，是最前面一级IF流水段的输入
	pipeif if_stage(pcsource,pc,bpc,da,jpc,npc,pc4,ins,mem_clock/*,if_flush*/); //finished
	//IF取指令模块，注意其中包含指令同步ROM存储器的同步信号
	//即输入给此模块的mem_clock在模块内定义为rom_clock
	//实验中可以采用系统clock的反相信号作为mem_clock（rom_clock）
	//即留给信号半个节拍的传输时间
	pipeir inst_reg(pc4,ins,wpcir,clock,resetn,dpc4,inst,if_flush); //finished
	//IF/ID流水线寄存器模块，起承接IF阶段和ID阶段的流水任务
	//在clock上升沿时，将IF阶段需传递给ID阶段的信息锁存在IF/ID寄存器
	//中，并呈现在ID阶段
	pipeid id_stage( mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst, 
							wrn,wdi,ealu,malu,mmo,wwreg,clock,resetn, 
							bpc,jpc,pcsource,wpcir,dwreg,dm2reg,dwmem,daluc, 
							daluimm,da,db,dimm,drn,dshift,djal,if_flush);  //finished
	//ID指令译码模块，其中包含CU，reg_file,多个MUX
	//其中寄存器堆会在clock的下沿进行寄存器写入，也就是给信号从WB段
	//传输过来留有半个clock的延迟时间，用来保持信号稳定
	pipedereg de_reg( dwreg,dm2reg,dwmem,daluc,daluimm,da,db,dimm,drn,dshift,
							 djal,dpc4,clock,resetn,ewreg,em2reg,ewmem,ealuc,ealuimm, 
							  ea,eb,eimm,ern0,eshift,ejal,epc4,wpcir);  //finished
	//ID/EXE流水线寄存器模块，起到承接ID阶段和EXE阶段的流水任务
	//在clock上升沿时，将ID阶段需要传递给EXE阶段的信息锁存在ID/EXE流水线寄存器
	//中，并呈现在EXE阶段
	pipeexe exe_stage(ealuc,ealuimm,ea,eb,eimm,eshift,ern0,epc4,ejal,ern,ealu); //finished
	//EXE运算模块，其中包含ALU和多个MUX
	pipeemreg em_reg( ewreg,em2reg,ewmem,ealu,eb,ern,clock,resetn, 
						 mwreg,mm2reg,mwmem,malu,mb,mrn); //finished
	//EXE/MEM流水线寄存器模块，起到承接EXE阶段和MEM阶段的流水任务
	//在clock上升沿时，将EXE阶段需要传递给MEM阶段的信息锁存在EXE/MEM
	//流水线寄存器中，并呈现在MEM阶段
	pipemem mem_stage( mwmem,malu,mb,clock,mem_clock,mmo,input_port1,input_port2,output_port); //finished
	//MEM数据存取模块，其中包含对数据同步RAM的读写访问
	//输入给该同步RAM的mem_clock信号，模块内定义为ram_clk
	//实验中采用与clock的反相信号作为mem_clock信号
	//留给信号半个节拍的传输时间，然后在mem_clock上升沿时，读输出或写输入
	pipemwreg mw_reg( mwreg,mm2reg,mmo,malu,mrn,clock,resetn, 
							wwreg,wm2reg,wmo,walu,wrn); //finished
	//MEM/WB流水线寄存器模块，起到承接MEM阶段和WB阶段的流水任务
	//在clock上升沿时，将MEM阶段需要传递给WB阶段的信息，锁存在MEM/WB
	//流水线寄存器中，并呈现在WB阶段
	mux2x32 wb_stage(walu,wmo,wm2reg,wdi);
	//WB写回阶段模块，该阶段的逻辑功能部件只包括一个MUX，
	//所以可以仅用一个MUX的实例来实现该部分
	//也可以写一个完整的模块	
endmodule

module BCD(data,hex_high,hex_low);
	input [4:0] data;
	output [6:0] hex_low,hex_high;
	reg [6:0] mid_low,mid_high;
	assign hex_high = mid_high;
	assign hex_low = mid_low;
	
	always @ (*)
	begin
		case(data)
			0,10,20,30: mid_low=7'b100_0000;				
			1,11,21,31: mid_low=7'b111_1001;
			2,12,22: mid_low=7'b010_0100;
			3,13,23: mid_low=7'b011_0000;
			4,14,24: mid_low=7'b001_1001;
			5,15,25: mid_low=7'b001_0010;
			6,16,26: mid_low=7'b000_0010;
			7,17,27: mid_low=7'b111_1000;
			8,18,28: mid_low=7'b000_0000;
			9,19,29: mid_low=7'b001_0000;
			default: mid_low=7'b1111111;
		endcase
		
		case(data)
			0,1,2,3,4,5,6,7,8,9: mid_high=7'b111_1111;
			10,11,12,13,14,15,16,17,18,19: mid_high=7'b111_1001;
			20,21,22,23,24,25,26,27,28,29: mid_high=7'b010_0100;
			30,31: mid_high=7'b011_0000;
		endcase
	end
endmodule

module pipeCPU(clock,resetn,op1,op2,inputLight,outputLight,testlight,hex1,hex2,hex3,hex4,hex5,hex6,hex7,hex8);
	input clock;
	input resetn;
	input [3:0] op1,op2;
	output [7:0] inputLight;
	output [4:0] outputLight;
	output testlight;
	output [6:0] hex1,hex2,hex3,hex4,hex5,hex6,hex7,hex8;
	
	wire mem_clock;
	wire [4:0] opt,show1,show2;
	wire [31:0] pc,inst,ealu,malu,walu;
	
	assign mem_clock=~clock;
	assign testlight = malu[7];
	assign outputLight = opt;
	assign inputLight[3:0] = op1;
	assign inputLight[7:4] = op2;
	assign show1 = {1'b0,op1};
	assign show2 = {1'b0,op2};
	assign hex5 = 7'b111_1111;
	assign hex8 = 7'b111_1111;
	
	//BCD BCD1(show1,hex2,hex1);
	//BCD BCD2(show2,hex4,hex3);
	BCD BCD3(opt,hex6,hex7);
	
	pipelined_computer CPU(resetn,clock,mem_clock,pc,
									inst,ealu,malu,walu,op1,op2,opt);
endmodule
