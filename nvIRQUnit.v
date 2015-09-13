`include defs.v


module nvIRQUnit(
	input wire[31:0]		IRQStatus,

	input wire[31:0]		reg_top_inner_nvIRQ,

	output wire				nvIRQRequest
);

	////////////////////////////////////////////
	assign nvIRQRequest = IRQStatus & reg_top_inner_nvIRQ;

endmodule
