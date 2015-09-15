`include "defs.v"

`timescale 1ns/1ps

module tb_IRQArbiter();

	reg[15:0]			 tb_vIRQRequest;
	reg 				tb_nvIRQRequest;

	initial begin
		tb_vIRQRequest <= 16'h0000;
		tb_nvIRQRequest <= 1'b0;

		fork
			forever begin
				#10 tb_nvIRQRequest <= 1'b1;
				#20 tb_vIRQRequest <= 16'h0100;
				#30 tb_vIRQRequest <= 16'h0f00;
				#40 tb_nvIRQRequest <= 1'b0;
				#50 tb_vIRQRequest <= 16'h0000;
			end

			#500 $stop;
		join
	end

	wire[3:0]			HandlerNum;
	wire				IsnvIRQ;
	wire				IRQRequest;

	IRQArbiter tb(.nvIRQRequest(tb_nvIRQRequest),
				.vIRQRequest(tb_vIRQRequest),
				.wire_IRQArbiter_HandlerNum(HandlerNum),
				.wire_IRQArbiter_IsnvIRQ(IsnvIRQ),
				.wire_VICIRQRequest(IRQRequest));

endmodule
