`include "defs.v"

`timescale 1ns/1ps

module tb_vIRQUnit();

	reg[31:0]			tb_VICVectCntlx;
	reg[31:0]			tb_IRQStatus;

	wire				vIRQRequest;

	initial begin
		tb_VICVectCntlx <= 32'h00000000;
		tb_IRQStatus <= 32'h00000000;

		fork
			forever begin
				#20 tb_VICVectCntlx[5] <= 1'b1;
				#25 tb_IRQStatus <= 32'hffffffff;
				#30 tb_VICVectCntlx[4:0] <= 5'b00001;
				#40 tb_VICVectCntlx[4:0] <= 5'b00010;
				#50 tb_VICVectCntlx[4:0] <= 5'b01010;
				#60 tb_IRQStatus <= 32'haaaaaaaa;
			end

			#500 $stop;
		join
	end

	vIRQUnit tb(.top_reg_VICVectCntlx(tb_VICVectCntlx),
				.IRQStatus(tb_IRQStatus),

				.vIRQRequest(vIRQRequest));

endmodule
