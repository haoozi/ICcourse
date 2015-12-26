`include "defs.v"


module vic_top(
	input            presetn,
    input            pclk,
    input            pselVIC,
    input            penable,
    input      [31:0] paddr,
    input            pwrite,
    input      [31:0]pwdata,
    output     [31:0]prdata,
    input [31:0]VICIntSource,
    output  nvicfiq,
    output  nvicirq
	);

	wire bus_en;

	assign bus_en = pselVIC & (penable);

	VIC_total VIC(
		.rst(presetn),				.clk(pclk),
		.VICFIQEn(1'b1),			.VICIRQEn(1'b1),
		.vic_intrsource(VICIntSource),	.bus_addr(paddr),
		.bus_wr(pwrite),			.bus_en(bus_en),
		.bus_data_i(pwdata),		.bus_data_o(prdata),

		//input wire						is_priviledge,

		.nVICFIQ(nvicfiq),			.nVICIRQ(nvicirq)
		);


endmodule
