`include defs.v

module FIQUnit(
	input wire				VICFIQEn,
	input wire[31:0]		FIQStatus,

	output wire				wire_VICFIQRequest
);

	//VICFIQRequest : 1 is valid
	assign wire_VICFIQRequest = (VICFIQEn == 1'b1) ?  |FIQStatus : 1'b0;


endmodule
