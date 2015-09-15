`include "defs.v"

`timescale 1ns/1ps

module tb_int_gen();

    reg[31:0]           VICSoftInt;
    reg[31:0]           VICSoftIntClear;
    reg[31:0]           VICIntSelect;
    reg[31:0]           VICIntEnable;
    reg[31:0]           VICIntEnClr;

    reg[31:0]           Fake_VICIntrSource;

    wire[31:0]          VICRawIntr;

    wire[31:0]          FIQStatus;
    wire[31:0]          IRQStatus;

    initial begin
        VICSoftInt <= 32'h00000000;
        VICSoftIntClear <= 32'h00000000;
        VICIntSelect <= 32'h00000000;
        VICIntEnable <= 32'hFFFFFFFF;
        VICIntEnClr <= 32'h00000000;

        Fake_VICIntrSource <= 32'h00000000;

        fork
            forever begin
                #10 Fake_VICIntrSource <= 32'h00000000;
                #20 Fake_VICIntrSource <= 32'h00000001;
                #30 Fake_VICIntrSource <= 32'h0000000F;
                #40 Fake_VICIntrSource <= 32'h000000F0;
            end

            forever begin
                #40 VICIntSelect <= 32'h00000000;
                #80 VICIntSelect <= 32'hAAAAAAAA;
                #120 VICIntSelect <= 32'hFFFFFFFF;
            end

            forever begin
                #120 VICIntEnable <= 32'h00000000;
                #130 VICIntEnable <= 32'hFFFFFFFF;
            end

            forever begin
                #5 VICIntEnClr <= 32'hFFFFFFFF;
                #10 VICIntEnClr <= 32'h00000000;
            end

            #1000 $stop;
        join

    end

    int_gen ts(.top_reg_VICSoftInt(VICSoftInt),
                .top_reg_VICSoftIntClear(VICSoftIntClear),
                .top_reg_VICIntSelect(VICIntSelect),
                .top_reg_VICIntEnable(VICIntEnable),
                .top_reg_VICIntEnClr(VICIntEnClr),

                .VICIntrSource(Fake_VICIntrSource),
                .intgen_reg_VICRawIntr(VICRawIntr),
                .FIQStatus(FIQStatus),
                .IRQStatus(IRQStatus));

endmodule
