`include defs.v

module VIC_top(
	input wire						rst,
	input wire						clk,

	input wire [`VIC_INTW-1:0]		vic_intr,
	input wire [`ADDR_BW-1:0]		bus_addr,
	input wire						bus_wr,
	input wire						bus_en,

	input wire						is_priviledge,
	
	inout wire [`DATA_BW-1:0]		bus_data,

	output wire						nVICFIQ,
	output wire						nVICIRQ,
	output wire [`ADDR_BW-1:0]		VICVECTADDROUT
	);

	//0xFFFF F000 RO
	reg[31:0]						regs_VICIRQStatus;
	//0xFFFF F004 RO
	reg[31:0]						regs_VICFIQStatus;
	//0xFFFF F008 RO
	reg[31:0]						regs_VICRawIntr;
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
		if (bus_en == `BusEnable) begin
			if (bus_wr == `BusWriteable) begin
				//write regs
			end else begin
				//read regs
				reg_bus_inout <= 1'b1;
			end
		end
	end





endmodule
