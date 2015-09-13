`include defs.v

module FIQUnit(
	input wire				VICFIQEn,
	input wire[31:0]		FIQStatus,

	output wire				VICFIQRequest
);

	//VICFIQRequest : 1 is valid
	assign VICFIQRequest = |FIQStatus;


endmodule
