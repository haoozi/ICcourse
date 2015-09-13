`include defs.v

module vIRQUnit(
	input wire[31:0]		top_reg_VICVectCntlx,
	input wire[31:0]		IRQStatus,

	output wire				vIRQRequest
);

	wire					vIRQ_Enabled;
	wire[4:0]				vIRQ_Source;

	assign vIRQ_Enabled = top_reg_VICVectCntlx[5];
	assign vIRQ_Source = top_reg_VICVectCntlx[4:0];


	assign vIRQRequest = (vIRQ_Enabled == 1'b1) ? IRQStatus[vIRQ_Source] : 1'b0;


endmodule
