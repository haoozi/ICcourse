`include "defs.v"

module int_gen(
	// input wire				rst,
	input wire[31:0]		top_reg_VICSoftInt,
	input wire[31:0]		top_reg_VICSoftIntClear,
	input wire[31:0]		top_reg_VICIntSelect,
	input wire[31:0]		top_reg_VICIntEnable,
	input wire[31:0]		top_reg_VICIntEnClr,

	input wire[31:0]		VICIntrSource,

	output wire[31:0]		intgen_reg_VICRawIntr,


	output wire[31:0]		FIQStatus,
	output wire[31:0]		IRQStatus
);



	wire[31:0]				reg_VICRawIntr;

	wire[31:0]				SoftIntrSource;

	wire[31:0]				IntrEnabled;


	assign intgen_reg_VICRawIntr = reg_VICRawIntr;

	assign SoftIntrSource = (top_reg_VICSoftInt) & (~top_reg_VICSoftIntClear);

	assign reg_VICRawIntr = VICIntrSource | SoftIntrSource;

	assign IntrEnabled = reg_VICRawIntr & top_reg_VICIntEnable;

	//VICIntSelect : 1 means FIQ
	assign FIQStatus = IntrEnabled & top_reg_VICIntSelect;
	assign IRQStatus = IntrEnabled & (~top_reg_VICIntSelect);


endmodule
