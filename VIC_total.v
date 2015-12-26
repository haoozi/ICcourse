`include "defs.v"

module VIC_total(
	input wire						rst,
	input wire						clk,

	input wire						VICFIQEn,
	input wire						VICIRQEn,
	input wire [31:0]				vic_intrsource,

	input wire [31:0]				bus_addr,
	input wire						bus_wr,
	input wire						bus_en,
	input wire [31:0]				bus_data_i,
	output wire [31:0]				bus_data_o,

	//input wire						is_priviledge,

	output wire						nVICFIQ,
	output wire						nVICIRQ
	//output wire[31:0]				VICVectAddrOut
	);

	reg[31:0]					masked_INTR;
	//VICIRQStatus
	wire[31:0]						vic_intr;

	assign vic_intr = vic_intrsource & (~masked_INTR);


	//0xFFFF F000 RO
	//int_gen->IRQStatus
	//reg[31:0]						regs_VICIRQStatus;

	//0xFFFF F004 RO
	//int_gen->FIQStatus
	//reg[31:0]						regs_VICFIQStatus;

	//0xFFFF F008 RO
	//int_gen->intgen_reg_VICRawIntr
	//reg[31:0]						regs_VICRawIntr;
	wire[31:0]						regs_VICRawIntr;

	//0xFFFF F00C RW
	reg[31:0]						regs_VICIntSelect;
	//0xFFFF F010 RW
	reg[31:0]						regs_VICIntEnable;
	//0xFFFF F014 WO
	//reg[31:0]						regs_VICIntEnClr;
	wire[31:0]						regs_VICIntEnClr;
	//0xFFFF F018 RW
	reg[31:0]						regs_VICSoftInt;
	//0xFFFF F01C WO
	//reg[31:0]						regs_VICSoftIntClear;
	wire[31:0]						regs_VICSoftIntClear;
	//0xFFFF F020 RW
	reg[31:0]						regs_VICProtection;



	//0xFFFF F030 RW
	reg[31:0]						regs_VICVectAddr;

	//0xFFFF F034 RW
	reg[31:0]						regs_VICDefVectAddr;

	//0xFFFF F100 RW
	reg[31:0]						regs_VICVectAddr_[0:15];

	//0xFFFF F200 RW
	reg[31:0]						regs_VICVectCntl[0:15];


	wire[31:0]						wire_inner_IRQEnabled;

	//wire[31:0]						bus_dout;

	reg[31:0]						reg_bus_dout;

	reg 							reg_nVICIRQ;

	assign nVICIRQ = reg_nVICIRQ;

	assign 	regs_VICSoftIntClear = 32'h00000000;
	assign  regs_VICIntEnClr = 32'h00000000;

	assign bus_data_o = reg_bus_dout;



	wire[31:0]						wire_inner_vIRQ;
	wire[31:0]						wire_inner_vIRQx[0:15];
	wire[31:0]						wire_inner_nvIRQ;

	assign wire_inner_vIRQx[0] = 32'h00000001 << regs_VICVectCntl[0][4:0];
	assign wire_inner_vIRQx[1] = 32'h00000001 << regs_VICVectCntl[1][4:0];
	assign wire_inner_vIRQx[2] = 32'h00000001 << regs_VICVectCntl[2][4:0];
	assign wire_inner_vIRQx[3] = 32'h00000001 << regs_VICVectCntl[3][4:0];
	assign wire_inner_vIRQx[4] = 32'h00000001 << regs_VICVectCntl[4][4:0];
	assign wire_inner_vIRQx[5] = 32'h00000001 << regs_VICVectCntl[5][4:0];
	assign wire_inner_vIRQx[6] = 32'h00000001 << regs_VICVectCntl[6][4:0];
	assign wire_inner_vIRQx[7] = 32'h00000001 << regs_VICVectCntl[7][4:0];
	assign wire_inner_vIRQx[8] = 32'h00000001 << regs_VICVectCntl[8][4:0];
	assign wire_inner_vIRQx[9] = 32'h00000001 << regs_VICVectCntl[9][4:0];
	assign wire_inner_vIRQx[10] = 32'h00000001 << regs_VICVectCntl[10][4:0];
	assign wire_inner_vIRQx[11] = 32'h00000001 << regs_VICVectCntl[11][4:0];
	assign wire_inner_vIRQx[12] = 32'h00000001 << regs_VICVectCntl[12][4:0];
	assign wire_inner_vIRQx[13] = 32'h00000001 << regs_VICVectCntl[13][4:0];
	assign wire_inner_vIRQx[14] = 32'h00000001 << regs_VICVectCntl[14][4:0];
	assign wire_inner_vIRQx[15] = 32'h00000001 << regs_VICVectCntl[15][4:0];

	assign wire_inner_vIRQ = wire_inner_vIRQx[0] |
								wire_inner_vIRQx[1] |
								wire_inner_vIRQx[2] |
								wire_inner_vIRQx[3] |
								wire_inner_vIRQx[4] |
								wire_inner_vIRQx[5] |
								wire_inner_vIRQx[6] |
								wire_inner_vIRQx[7] |
								wire_inner_vIRQx[8] |
								wire_inner_vIRQx[9] |
								wire_inner_vIRQx[10] |
								wire_inner_vIRQx[11] |
								wire_inner_vIRQx[12] |
								wire_inner_vIRQx[13] |
								wire_inner_vIRQx[14] |
								wire_inner_vIRQx[15];

	assign wire_inner_nvIRQ = (~regs_VICIntSelect) | (~wire_inner_vIRQ);


	assign wire_inner_IRQEnabled = (((regs_VICVectCntl[0][5] == 1'b1) ? wire_inner_vIRQx[0] : 32'h00000000 ) |
	((regs_VICVectCntl[1][5] == 1'b1) ? wire_inner_vIRQx[1] : 32'h00000000 ) |
	((regs_VICVectCntl[2][5] == 1'b1) ? wire_inner_vIRQx[2] : 32'h00000000 ) |
	((regs_VICVectCntl[3][5] == 1'b1) ? wire_inner_vIRQx[3] : 32'h00000000 ) |
	((regs_VICVectCntl[4][5] == 1'b1) ? wire_inner_vIRQx[4] : 32'h00000000 ) |
	((regs_VICVectCntl[5][5] == 1'b1) ? wire_inner_vIRQx[5] : 32'h00000000 ) |
	((regs_VICVectCntl[6][5] == 1'b1) ? wire_inner_vIRQx[6] : 32'h00000000 ) |
	((regs_VICVectCntl[7][5] == 1'b1) ? wire_inner_vIRQx[7] : 32'h00000000 ) |
	((regs_VICVectCntl[8][5] == 1'b1) ? wire_inner_vIRQx[8] : 32'h00000000 ) |
	((regs_VICVectCntl[9][5] == 1'b1) ? wire_inner_vIRQx[9] : 32'h00000000 ) |
	((regs_VICVectCntl[10][5] == 1'b1) ? wire_inner_vIRQx[10] : 32'h00000000 ) |
	((regs_VICVectCntl[11][5] == 1'b1) ? wire_inner_vIRQx[11] : 32'h00000000 ) |
	((regs_VICVectCntl[12][5] == 1'b1) ? wire_inner_vIRQx[13] : 32'h00000000 ) |
	((regs_VICVectCntl[13][5] == 1'b1) ? wire_inner_vIRQx[13] : 32'h00000000 ) |
	((regs_VICVectCntl[14][5] == 1'b1) ? wire_inner_vIRQx[14] : 32'h00000000 ) |
	((regs_VICVectCntl[15][5] == 1'b1) ? wire_inner_vIRQx[15] : 32'h00000000 ) )
	 | wire_inner_nvIRQ;



	wire[31:0]				conn_FIQStatus;
	wire[31:0]				conn_IRQStatus;
	wire					conn_nvIRQRequest;
	wire[15:0]				conn_vIRQRequest;
	wire[3:0]				conn_IRQHandlerNum;
	wire					conn_IRQ_IsnvIRQ;
	wire					conn_VICIRQRequest;

	wire 					VICFIQRequest;

	assign nVICFIQ = ~VICFIQRequest;



	int_gen InterruptGen(
		.top_reg_VICSoftInt(regs_VICSoftInt),
		.top_reg_VICSoftIntClear(regs_VICSoftIntClear),
		.top_reg_VICIntSelect(regs_VICIntSelect),
		.top_reg_VICIntEnable(regs_VICIntEnable),
		.top_reg_VICIntEnClr(regs_VICIntEnClr),

		.VICIntrSource(vic_intr),

		.intgen_reg_VICRawIntr(regs_VICRawIntr),
		.FIQStatus(conn_FIQStatus),
		.IRQStatus(conn_IRQStatus)
	);

	FIQUnit FIQContol(
		.VICFIQEn(VICFIQEn),
		.FIQStatus(conn_FIQStatus),
		.wire_VICFIQRequest(VICFIQRequest)
	);

	nvIRQUnit nvIRQContol(
		.IRQStatus(conn_IRQStatus),
		.reg_top_inner_nvIRQ(wire_inner_nvIRQ),
		.nvIRQRequest(conn_nvIRQRequest)
	);

	vIRQUnit vIRQContol0(
		.top_reg_VICVectCntlx(regs_VICVectCntl[0]),
		.IRQStatus(conn_IRQStatus),

		.vIRQRequest(conn_vIRQRequest[0])
		);

	vIRQUnit vIRQContol1(
		.top_reg_VICVectCntlx(regs_VICVectCntl[1]),
		.IRQStatus(conn_IRQStatus),

		.vIRQRequest(conn_vIRQRequest[1])
		);

	vIRQUnit vIRQContol2(
		.top_reg_VICVectCntlx(regs_VICVectCntl[2]),
		.IRQStatus(conn_IRQStatus),

		.vIRQRequest(conn_vIRQRequest[2])
		);

	vIRQUnit vIRQContol3(
		.top_reg_VICVectCntlx(regs_VICVectCntl[3]),
		.IRQStatus(conn_IRQStatus),

		.vIRQRequest(conn_vIRQRequest[3])
		);

	vIRQUnit vIRQContol4(
		.top_reg_VICVectCntlx(regs_VICVectCntl[4]),
		.IRQStatus(conn_IRQStatus),

		.vIRQRequest(conn_vIRQRequest[4])
		);

	vIRQUnit vIRQContol5(
		.top_reg_VICVectCntlx(regs_VICVectCntl[5]),
		.IRQStatus(conn_IRQStatus),

		.vIRQRequest(conn_vIRQRequest[5])
		);

	vIRQUnit vIRQContol6(
		.top_reg_VICVectCntlx(regs_VICVectCntl[6]),
		.IRQStatus(conn_IRQStatus),

		.vIRQRequest(conn_vIRQRequest[6])
		);

	vIRQUnit vIRQContol7(
		.top_reg_VICVectCntlx(regs_VICVectCntl[7]),
		.IRQStatus(conn_IRQStatus),

		.vIRQRequest(conn_vIRQRequest[7])
		);

	vIRQUnit vIRQContol8(
		.top_reg_VICVectCntlx(regs_VICVectCntl[8]),
		.IRQStatus(conn_IRQStatus),

		.vIRQRequest(conn_vIRQRequest[8])
		);

	vIRQUnit vIRQContol9(
		.top_reg_VICVectCntlx(regs_VICVectCntl[9]),
		.IRQStatus(conn_IRQStatus),

		.vIRQRequest(conn_vIRQRequest[9])
		);

	vIRQUnit vIRQContol10(
		.top_reg_VICVectCntlx(regs_VICVectCntl[10]),
		.IRQStatus(conn_IRQStatus),

		.vIRQRequest(conn_vIRQRequest[10])
		);

	vIRQUnit vIRQContol11(
		.top_reg_VICVectCntlx(regs_VICVectCntl[11]),
		.IRQStatus(conn_IRQStatus),

		.vIRQRequest(conn_vIRQRequest[11])
		);

	vIRQUnit vIRQContol12(
		.top_reg_VICVectCntlx(regs_VICVectCntl[12]),
		.IRQStatus(conn_IRQStatus),

		.vIRQRequest(conn_vIRQRequest[12])
		);

	vIRQUnit vIRQContol13(
		.top_reg_VICVectCntlx(regs_VICVectCntl[13]),
		.IRQStatus(conn_IRQStatus),

		.vIRQRequest(conn_vIRQRequest[13])
		);

	vIRQUnit vIRQContol14(
		.top_reg_VICVectCntlx(regs_VICVectCntl[14]),
		.IRQStatus(conn_IRQStatus),

		.vIRQRequest(conn_vIRQRequest[14])
		);

	vIRQUnit vIRQContol15(
		.top_reg_VICVectCntlx(regs_VICVectCntl[15]),
		.IRQStatus(conn_IRQStatus),

		.vIRQRequest(conn_vIRQRequest[15])
		);



	IRQArbiter Arbiter(
		.nvIRQRequest(conn_nvIRQRequest),
		.vIRQRequest(conn_vIRQRequest),
		.wire_IRQArbiter_HandlerNum(conn_IRQHandlerNum),
		.wire_IRQArbiter_IsnvIRQ(conn_IRQ_IsnvIRQ),
		.wire_VICIRQRequest(conn_VICIRQRequest)
		);

	reg[31:0]					VICVectAddr_delay;

	/*always @(posedge clk) begin
		VICVectAddr_delay <= regs_VICVectAddr;
	end*/
	always @(bus_en) begin
		if (bus_en == 1'b1) begin
			VICVectAddr_delay <= regs_VICVectAddr;
			end
	end

	always @(*) begin
		if (rst == `RstEnable) begin
			begin
				regs_VICIntSelect 			<= `RegRstValue;
				regs_VICIntEnable 			<= `RegRstValue;
				regs_VICSoftInt 			<= `RegRstValue;
				regs_VICProtection 			<= `RegRstValue;
				regs_VICDefVectAddr			<= `RegRstValue;
				regs_VICVectAddr_[0]		<= `RegRstValue;
				regs_VICVectAddr_[1]		<= `RegRstValue;
				regs_VICVectAddr_[2]		<= `RegRstValue;
				regs_VICVectAddr_[3]		<= `RegRstValue;
				regs_VICVectAddr_[4]		<= `RegRstValue;
				regs_VICVectAddr_[5]		<= `RegRstValue;
				regs_VICVectAddr_[6]		<= `RegRstValue;
				regs_VICVectAddr_[7]		<= `RegRstValue;
				regs_VICVectAddr_[8]		<= `RegRstValue;
				regs_VICVectAddr_[9]		<= `RegRstValue;
				regs_VICVectAddr_[10]		<= `RegRstValue;
				regs_VICVectAddr_[11]		<= `RegRstValue;
				regs_VICVectAddr_[12]		<= `RegRstValue;
				regs_VICVectAddr_[13]		<= `RegRstValue;
				regs_VICVectAddr_[14]		<= `RegRstValue;
				regs_VICVectAddr_[15]		<= `RegRstValue;

				regs_VICVectCntl[0]			<= `RegRstValue;
				regs_VICVectCntl[1]			<= `RegRstValue;
				regs_VICVectCntl[2]			<= `RegRstValue;
				regs_VICVectCntl[3]			<= `RegRstValue;
				regs_VICVectCntl[4]			<= `RegRstValue;
				regs_VICVectCntl[5]			<= `RegRstValue;
				regs_VICVectCntl[6]			<= `RegRstValue;
				regs_VICVectCntl[7]			<= `RegRstValue;
				regs_VICVectCntl[8]			<= `RegRstValue;
				regs_VICVectCntl[9]			<= `RegRstValue;
				regs_VICVectCntl[10]		<= `RegRstValue;
				regs_VICVectCntl[11]		<= `RegRstValue;
				regs_VICVectCntl[12]		<= `RegRstValue;
				regs_VICVectCntl[13]		<= `RegRstValue;
				regs_VICVectCntl[14]		<= `RegRstValue;
				regs_VICVectCntl[15]		<= `RegRstValue;

				reg_bus_dout 				<= `RegRstValue;
			end
		end else begin
			if (bus_en == `BusEnable) begin
				if (bus_wr == `BusWrite) begin
					if (regs_VICProtection != 32'h00000000) begin
					end else begin
						casex (bus_addr)
							32'hfffff000 : begin
									//RO
								end

							32'hfffff004: begin
									//RO
								end

							32'hfffff008 : begin
									//RO
								end

							32'hfffff00c : begin
									regs_VICIntSelect <= bus_data_i;
								end

							32'hfffff010 : begin
									regs_VICIntEnable <= bus_data_i;
								end

							32'hfffff014 : begin
									//regs_VICIntEnable <= bus_data_i;
									regs_VICIntEnable <= regs_VICIntEnable & (~bus_data_i);
								end

							32'hfffff018 : begin
									regs_VICSoftInt <= bus_data_i;
								end

							32'hfffff01c : begin
									//WO
									regs_VICSoftInt <= regs_VICSoftInt & (~bus_data_i);
								end

							32'hfffff020 : begin
									regs_VICProtection <= bus_data_i;
								end

							32'hfffff030 : begin
									//RO
								end

							32'hfffff034 : begin
									regs_VICDefVectAddr <= bus_data_i;
								end

							32'hfffff1xx : begin
									regs_VICVectAddr_[bus_addr[7:2]] <= bus_data_i;
								end

							32'hfffff2xx : begin
									regs_VICVectCntl[bus_addr[7:2]] <= bus_data_i;
								end

							default : begin

								end
						endcase
					end
				end else begin
					//read regs
					casex (bus_addr)
						32'hfffff000 : begin
								reg_bus_dout <= wire_inner_IRQEnabled;
							end

						32'hfffff004: begin
								reg_bus_dout <= conn_FIQStatus;
							end

						32'hfffff008 : begin
								reg_bus_dout <= regs_VICRawIntr;
							end

						32'hfffff00c : begin
								reg_bus_dout <= regs_VICIntSelect;
							end

						32'hfffff010 : begin
								reg_bus_dout <= regs_VICIntEnable;
							end

						32'hfffff014 : begin
								//WO
								reg_bus_dout <= 32'h00000000;
							end

						32'hfffff018 : begin
								reg_bus_dout <= regs_VICSoftInt;
							end

						32'hfffff01c : begin
								reg_bus_dout <= 32'h00000000;
							end

						32'hfffff020 : begin
								reg_bus_dout <= regs_VICProtection;
							end

						32'hfffff030 : begin
								reg_bus_dout <= VICVectAddr_delay;
							end

						32'hfffff034 : begin
								reg_bus_dout <= regs_VICDefVectAddr;
							end

						32'hfffff1xx : begin
								reg_bus_dout <= regs_VICVectAddr_[bus_addr[7:2]];
							end

						32'hfffff200 : begin
								reg_bus_dout <= regs_VICVectCntl[bus_addr[7:2]];
							end

						default : begin
								reg_bus_dout <= 32'h00000000;
							end
					endcase
				end
			end
		end
	end


	always @(*) begin
		if (rst == `RstEnable) begin
			reg_nVICIRQ <= 1'b1;
			regs_VICVectAddr <= 32'h00000000;
			masked_INTR <= 32'h00000000;
		end

		masked_INTR <= masked_INTR & vic_intrsource;

		if ((bus_en == `BusEnable) && (bus_wr != `BusWrite) && bus_addr == 32'hFFFFF030 && conn_VICIRQRequest == 1'b1) begin
			if (conn_VICIRQRequest == 1'b1) begin
				masked_INTR[regs_VICVectCntl[conn_IRQHandlerNum][4:0]] <= 1'b1;
			end else begin
				masked_INTR <= (masked_INTR) & (~conn_FIQStatus);
			end
		end else begin
			if (conn_VICIRQRequest == 1'b1 && (masked_INTR == 32'h00000000)) begin
				if (conn_IRQ_IsnvIRQ == 1'b0) begin
					//vIRQReuqest
					regs_VICVectAddr <= regs_VICVectAddr_[conn_IRQHandlerNum];
					reg_nVICIRQ <= 1'b0;
				end else begin
					//nvIRQRequest
					regs_VICVectAddr <= regs_VICDefVectAddr;
					reg_nVICIRQ <= 1'b0;
				end
			end else begin
				reg_nVICIRQ <= 1'b1;
				regs_VICVectAddr <= 32'h00000000;
			end
		end

	end

endmodule
