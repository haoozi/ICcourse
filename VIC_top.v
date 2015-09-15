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
	);


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





endmodule
