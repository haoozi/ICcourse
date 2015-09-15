`include "defs.v"

`timescale 1ns/1ps

module tb_FIQUnit();

    reg             tb_EN;
    reg[31:0]       tb_FIQStatus;

    initial fork
        tb_EN = 1'b0;
        #100 tb_EN = 1'b1;
        #600 $stop;
    join

    initial begin
        tb_FIQStatus = 32'h00000000;

        forever begin
            #10 tb_FIQStatus = 32'h4a0000a4;
            #20 tb_FIQStatus = 32'h00000000;
        end
    end

    wire EN;
    wire[31:0] FIQStatus;
    wire FIQRequest;

    assign EN = tb_EN;
    assign FIQStatus = tb_FIQStatus;


    FIQUnit tbb(.VICFIQEn(EN),
                .FIQStatus(FIQStatus),
                .wire_VICFIQRequest(FIQRequest));

endmodule
