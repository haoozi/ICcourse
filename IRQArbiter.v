`include "defs.v"


module IRQArbiter(
	input wire			nvIRQRequest,
	//come from nvirqunit
	input wire[15:0]	vIRQRequest,

	output wire[3:0]	wire_IRQArbiter_HandlerNum,
	output wire			wire_IRQArbiter_IsnvIRQ,
	output wire			wire_VICIRQRequest
);

	assign wire_IRQArbiter_IsnvIRQ = (vIRQRequest == 16'h0000) ? nvIRQRequest : 1'b0;

	assign wire_VICIRQRequest = ({vIRQRequest, nvIRQRequest} == {17{1'b0}}) ? 1'b0 : 1'b1;

	reg[3:0]			IntrNum;
	assign wire_IRQArbiter_HandlerNum = IntrNum;

	always @(vIRQRequest) begin
		casex (vIRQRequest)
			16'bxxxxxxxxxxxxxxx1:
				IntrNum <= 4'h0;
			16'bxxxxxxxxxxxxxx10:
				IntrNum <= 4'h1;
			16'bxxxxxxxxxxxxx100:
				IntrNum <= 4'h2;
			16'bxxxxxxxxxxxx1000:
				IntrNum <= 4'h3;
			16'bxxxxxxxxxxx10000:
				IntrNum <= 4'h4;
			16'bxxxxxxxxxx100000:
				IntrNum <= 4'h5;
			16'bxxxxxxxxx1000000:
				IntrNum <= 4'h6;
			16'bxxxxxxxx10000000:
				IntrNum <= 4'h7;
			16'bxxxxxxx100000000:
				IntrNum <= 4'h8;
			16'bxxxxxx1000000000:
				IntrNum <= 4'h9;
			16'bxxxxx10000000000:
				IntrNum <= 4'ha;
			16'bxxxx100000000000:
				IntrNum <= 4'hb;
			16'bxxx1000000000000:
				IntrNum <= 4'hc;
			16'bxx10000000000000:
				IntrNum <= 4'hd;
			16'bx100000000000000:
				IntrNum <= 4'he;
			16'b1000000000000000:
				IntrNum <= 4'hf;
			16'b0000000000000000:
				IntrNum <= 4'h0;
			default:
				IntrNum <= 4'h0;
		endcase
	end



endmodule
