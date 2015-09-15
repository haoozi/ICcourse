`include "defs.v"

module VIC_top(
	input wire						rst,
	input wire						clk,

	input wire						VICFIQEn,
	input wire						VICIRQEn,

	input wire [`VIC_INTW-1:0]		vic_intr,
	input wire [`ADDR_BW-1:0]		bus_addr,
	input wire						bus_wr,
	input wire						bus_en,

	input wire						is_priviledge,

	inout wire [`DATA_BW-1:0]		bus_data,

	//should be reg
	output wire						nVICFIQ,
	output wire						nVICIRQ,
	output wire [`ADDR_BW-1:0]		VICVECTADDROUT
	);

	//0xFFFF F000 RO
	//int_gen->IRQStatus
	//reg[31:0]						regs_VICIRQStatus;

	//0xFFFF F004 RO
	//int_gen->FIQStatus
	//reg[31:0]						regs_VICFIQStatus;

	//0xFFFF F008 RO
	//int_gen->intgen_reg_VICRawIntr
	//reg[31:0]						regs_VICRawIntr;

	//0xFFFF F00C RW
	reg[31:0]						regs_VICIntSelect;
	//0xFFFF F010 RW
	reg[31:0]						regs_VICIntEnable;
	//0xFFFF F014 WO
	reg[31:0]						regs_VICIntEnClr;
	//0xFFFF F018 RW
	reg[31:0]						regs_VICSoftInt;
	//0xFFFF F01C WO
	reg[31:0]						regs_VICSoftIntClear;
	//0xFFFF F020 RW
	reg[31:0]						regs_VICProtection;


	//0xFFFF F030 RW
	reg[31:0]						regs_VICVectAddr;

	//0xFFFF F034 RW
	reg[31:0]						regs_VICDefVectAddr;

	//0xFFFF F100 RW
	reg[31:0]						regs_VICVectAddr_[0:15];

	//0xFFFF F200 RW
	reg[31:0]						regs_VICVectCntl[0:15];



	wire							bus_inout;
	wire[31:0]						bus_dout;

	reg								reg_bus_inout;
	reg[31:0]						reg_bus_dout;

	assign bus_dout = reg_bus_dout;
	assign bus_inout = reg_bus_inout;

	//bus_inout == 1'b1: output
	assign bus_data = (bus_inout == 1'b1) ? bus_dout : {32{1'bz}};


	//posedge : as BUS_EN = 1
	always @(posedge bus_en or negedge rst) begin
		if (rst == `RstEnable) begin
			//all set to zero
			reg_bus_inout <= 1'b0;
		end

		//bus_en == 1'b1 bus enable
		//VICSoftInt & VICSoftIntClear should be handled here
		if (bus_en == `BusEnable) begin
			if (bus_wr == `BusWriteable) begin
				//write regs
			end else begin
				//read regs
				reg_bus_inout <= 1'b1;
			end
		end
	end



	wire[31:0]						wire_inner_nvIRQ;
	wire[31:0]						wire_inner_nvIRQx[0:15];
	wire[31:0]						wire_inner_vIRQ;

	assign wire_inner_nvIRQ[0] = 32'h00000001 << regs_VICVectCntl[0][4:0];
	assign wire_inner_nvIRQ[1] = 32'h00000001 << regs_VICVectCntl[1][4:0];
	assign wire_inner_nvIRQ[2] = 32'h00000001 << regs_VICVectCntl[2][4:0];
	assign wire_inner_nvIRQ[3] = 32'h00000001 << regs_VICVectCntl[3][4:0];
	assign wire_inner_nvIRQ[4] = 32'h00000001 << regs_VICVectCntl[4][4:0];
	assign wire_inner_nvIRQ[5] = 32'h00000001 << regs_VICVectCntl[5][4:0];
	assign wire_inner_nvIRQ[6] = 32'h00000001 << regs_VICVectCntl[6][4:0];
	assign wire_inner_nvIRQ[7] = 32'h00000001 << regs_VICVectCntl[7][4:0];
	assign wire_inner_nvIRQ[8] = 32'h00000001 << regs_VICVectCntl[8][4:0];
	assign wire_inner_nvIRQ[9] = 32'h00000001 << regs_VICVectCntl[9][4:0];
	assign wire_inner_nvIRQ[10] = 32'h00000001 << regs_VICVectCntl[10][4:0];
	assign wire_inner_nvIRQ[11] = 32'h00000001 << regs_VICVectCntl[11][4:0];
	assign wire_inner_nvIRQ[12] = 32'h00000001 << regs_VICVectCntl[12][4:0];
	assign wire_inner_nvIRQ[13] = 32'h00000001 << regs_VICVectCntl[13][4:0];
	assign wire_inner_nvIRQ[14] = 32'h00000001 << regs_VICVectCntl[14][4:0];
	assign wire_inner_nvIRQ[15] = 32'h00000001 << regs_VICVectCntl[15][4:0];

	assign wire_inner_vIRQ = wire_inner_nvIRQ[0] |
                                wire_inner_nvIRQ[1] |
                                wire_inner_nvIRQ[2] |
                                wire_inner_nvIRQ[3] |
                                wire_inner_nvIRQ[4] |
                                wire_inner_nvIRQ[5] |
                                wire_inner_nvIRQ[6] |
                                wire_inner_nvIRQ[7] |
                                wire_inner_nvIRQ[8] |
                                wire_inner_nvIRQ[9] |
                                wire_inner_nvIRQ[10] |
                                wire_inner_nvIRQ[11] |
                                wire_inner_nvIRQ[12] |
                                wire_inner_nvIRQ[13] |
                                wire_inner_nvIRQ[14] |
                                wire_inner_nvIRQ[15];

	assign wire_inner_nvIRQ = (~regs_VICIntSelect) | (~wire_inner_vIRQ);



	wire[3:0]				wire_IRQArbiter_HandlerNum;
	wire[31:0]				wire_inner_vIRQVectAddr;

	assign wire_inner_vIRQVectAddr = regs_VICVectAddr_[wire_IRQArbiter_HandlerNum];


endmodule
