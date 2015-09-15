`include "defs.v"

`timescale 1ns/1ps

module tb_nvIRQUnit();

	reg[31:0]			tb_nvIRQ;
	reg[31:0]			tb_IRQStatus;

	wire				nvIRQRequest;

	initial begin
		tb_nvIRQ <= 32'h00000000;
		tb_IRQStatus <= 32'h00000000;

		fork
			forever begin
				//#20 tb_nvIRQ <= 32'h00000000;
				#25 tb_IRQStatus <= 32'h0a000000;
				#60 tb_IRQStatus <= 32'haaaaaaaa;
				#80 tb_nvIRQ <= 32'h00000007;
			end

			#500 $stop;
		join
	end

	nvIRQUnit tb(.reg_top_inner_nvIRQ(tb_nvIRQ),
				.IRQStatus(tb_IRQStatus),

				.nvIRQRequest(nvIRQRequest));

endmodule
