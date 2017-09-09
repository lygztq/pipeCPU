module pipeid( mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst, 
							wrn,wdi,ealu,malu,mmo,wwreg,clock,resetn, 
							bpc,jpc,pcsource,wpcir,dwreg,dm2reg,dwmem,daluc, 
							daluimm,da,db,dimm,drn,dshift,djal,if_flush);
	input [31:0] wdi,ealu,malu,mmo;
	input mwreg,mm2reg,ewreg,em2reg,wwreg;
	//mmo:		MEM阶段直连到ID阶段的从mem中lw来的数据
	//某alu:		某阶段的流水线寄存器存储的alu结果数据
	//wdi:		WB写回寄存器的数据
	//某wreg:	某阶段写regfile信号的回执
	//某rn:		某阶段选择写回的寄存器号码
	//某m2reg:	某阶段是否需要从mem写回regfile的数据
	input [31:0] dpc4,inst; //dpc4:id阶段的pc+4
	input clock,resetn;
	output [31:0] bpc,jpc,da,db,dimm;
	output [1:0] pcsource;
	output [3:0] daluc;
	input [4:0] mrn,wrn,ern;
	output [4:0] drn;
	output wpcir,dwreg/**/,dm2reg/**/,dwmem,daluimm,dshift,djal/**/,if_flush;
	
	//wire mid_dwreg,mid_dm2reg,mid_dwmem;
	//wire [1:0] mid_pcsource;
	
	wire rsrtequ,sext,regrt;
	wire [4:0] rs,rt,rd;
	wire [5:0] op,func;
	wire [1:0] fwda,fwdb;
	wire e = sext & inst[15]; //逻辑或代数符号扩展的扩展单位，sext决定什么种类的扩展
	wire [15:0] imm = {16{e}}; //符号扩展
	wire [31:0] jpc = {dpc4[31:28],inst[25:0],1'b0,1'b0}; //j指令对应的扩展的立即数
	wire [31:0] offset = {imm[13:0],inst[15:0],1'b0,1'b0}; //beq或bne指令对应的偏移量扩展数
	wire [31:0] dimm = {imm,inst[15:0]}; //立即数操作数扩展数
	wire mem_clock = ~clock;
	wire [31:0] qa,qb;//从regfile中读出来的内容

	assign bpc = dpc4 + offset; //bne或beq对应pc
	
	//bubble bub(wpcir,mid_dwreg,mid_dm2reg,mid_dwmem,mid_pcsource,dwreg,dm2reg,dwmem,pcsource);
	divide_inst dinst(inst,rs,rt,rd,op,func);
	mux2x5 reg_wn (rd,rt,regrt,drn);
	
	fw fw_instance(rs,rt,fwda,fwdb,ewreg,ern,mwreg,mrn,em2reg,mm2reg,wpcir,clock);
	pipe_cu cu(op,func,rsrtequ,dwmem,dwreg,regrt,dm2reg,
                        daluc,dshift,daluimm,pcsource,djal,sext,if_flush);
	equ a_equ_b(da,db,rsrtequ);
	regfile rf(rs,rt,wdi,wrn,wwreg,mem_clock,resetn,qa,qb);
	mux4x32 data_a(qa,ealu,malu,mmo,fwda,da);
	mux4x32 data_b(qb,ealu,malu,mmo,fwdb,db);	
	//inst[25:21]:rs, inst[20:16]:rt
endmodule

module bubble(wpcir,mid_dwreg,mid_dm2reg,mid_dwmem,mid_pcsource,dwreg,dm2reg,dwmem,pcsource);
	input wpcir,mid_dwmem,mid_dwreg,mid_dm2reg;
	input [1:0] mid_pcsource;
	output dwreg,dm2reg,dwmem;
	output [1:0] pcsource;
	
	assign dwreg = wpcir & mid_dwreg;
	assign dm2reg = wpcir & mid_dm2reg;
	assign dwmem = wpcir & mid_dwmem;
	assign pcsource = mid_pcsource;
	
endmodule

module divide_inst(inst,rs,rt,rd,op,func);
	input [31:0] inst;
	output [4:0] rs,rt,rd;
	output [5:0] op,func;
	
	assign rs = inst[25:21];
	assign rt = inst[20:16];
	assign rd = inst[15:11];
	assign op = inst[31:26];
	assign func = inst[5:0];
	
endmodule

module fw(rs,rt,fwda,fwdb,ewreg,ern,mwreg,mrn,em2reg,mm2reg,wpcir,clock);
	input [4:0] ern,mrn,rs,rt;
	input clock;
	input ewreg,mwreg,em2reg,mm2reg;
	output [1:0] fwda,fwdb;
	output wpcir;
	
	reg wpcir;
	reg [1:0] fwda,fwdb;
	
	always @(*)
	begin
		if(em2reg & ((rt == ern) | (rs == ern)))
			wpcir = 0;
		else wpcir = 1;
	end
	
	always @(*)
	begin
		if(ewreg & (ern != 0) & (ern==rs) & ~em2reg)
			fwda = 2'b01; //选择exe_alu
		else if(mwreg & (mrn!=0) & (mrn==rs) & ~mm2reg)
				fwda = 2'b10; //选择mem_alu
		else if(mwreg & (mrn!=0) & (mrn == rs) & mm2reg)
					fwda = 2'b11; //选择mem_lw
		else fwda = 2'b00; //无数据冒险
	end
	
	always @(*)
	begin
		if(ewreg & (ern!=0) & (ern==rt) & ~em2reg)
			fwdb = 2'b01; //选择exe_alu
		else if(mwreg & (mrn!=0) & (mrn==rt) & ~mm2reg)
				fwdb = 2'b10; //选择mem_alu
		else if(mwreg & (mrn!=0) & (mrn==rt) & mm2reg)
					fwdb = 2'b11; //选择mem_lw
		else fwdb = 2'b00; //无数据冒险
	end
	

	
endmodule

module equ(a,b,is_equ);
	input [31:0] a,b;
	output is_equ;
	
	reg mid;
	
	always @(*)
	begin
		if(a==b) mid<=1'b1;
		else mid <= 1'b0;
	end
	
	assign is_equ = mid;
	
endmodule
