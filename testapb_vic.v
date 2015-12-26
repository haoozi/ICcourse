`timescale 1ns/1ps

module testapb_vic;
//��testbench����ģ��CPU����
//----------------------------------------------------------
// INPUT wire definition --- apb_crc
//----------------------------------------------------------
reg        presetn;
reg        pclk;
reg        pselVIC;
reg        penable;
reg [31:0]  paddr;
reg        pwrite;
reg [31:0] pwdata;
reg [21:0] VICIntSource;
wire [31:0] prdata;
wire        nvicfiq;
wire        nvicirq;
reg [31:0]bianl;

initial
begin
    presetn = 1'b1;
    pclk    = 1'b0;
    pselVIC = 1'b0;
    penable = 1'b0;
    paddr   = 32'h00000000;
    pwrite  = 1'b0;
    pwdata  = 32'h0;
    VICIntSource=22'h00_0000;
    bianl=32'h0;
    #10 presetn = 1'b0;
    #10 presetn = 1'b1;
    #37;
 //���ȼ���int0-----int21���ν���
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f010;pwdata = 32'hffff_ffff;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write VICIntEnable

    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f00c;pwdata = 32'hffff_0000;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write VICIntSelect, 1 is FIQ

    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f034;pwdata = 32'hfff0_0000;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write VICDefVectAddr

    //Init VICVectAddrs
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f100;pwdata = 32'hfff0_0010;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write VICVectAddr0

    //Test VICVectAddr0
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b0;paddr = 32'hffff_f100;    #10 penable = 1'b1;   bianl=prdata;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    bianl=prdata;     //read
    wait(bianl==32'hfff0_0010);

    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f104;pwdata = 32'hfff0_0011;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write VICVectAddr1
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f108;pwdata = 32'hfff0_0012;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f10c;pwdata = 32'hfff0_0013;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f110;pwdata = 32'hfff0_0014;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f114;pwdata = 32'hfff0_0015;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f118;pwdata = 32'hfff0_0016;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f11c;pwdata = 32'hfff0_0017;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f120;pwdata = 32'hfff0_0018;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f124;pwdata = 32'hfff0_0019;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f128;pwdata = 32'hfff0_001A;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f12c;pwdata = 32'hfff0_001B;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f130;pwdata = 32'hfff0_001C;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f134;pwdata = 32'hfff0_001D;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f138;pwdata = 32'hfff0_001E;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write VICVectAddr14

    //VICVectCntls
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f200;pwdata = 32'h0000_0020;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f204;pwdata = 32'h0000_0021;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f208;pwdata = 32'h0000_0022;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f20c;pwdata = 32'h0000_0023;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f210;pwdata = 32'h0000_0024;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f214;pwdata = 32'h0000_0025;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f218;pwdata = 32'h0000_0026;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f21c;pwdata = 32'h0000_0027;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f220;pwdata = 32'h0000_0028;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f224;pwdata = 32'h0000_0029;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f228;pwdata = 32'h0000_002A;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f22c;pwdata = 32'h0000_002B;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f230;pwdata = 32'h0000_002C;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f234;pwdata = 32'h0000_002D;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f238;pwdata = 32'h0000_002E;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f010;pwdata = 32'h00ff_ffff;#10 penable = 1'b1;
    #10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;    //write
    #50;

#10 VICIntSource=22'b00_0000_0000_0000_0000_1000;//int3 req appear
#10;
#10;
//CPU read paddr = 32'hffff_f030
#10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b0;paddr = 32'hffff_f030;    #10 penable = 1'b1;   bianl=prdata;
#10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;         //read
#20;
#10;
#10 VICIntSource=22'b00_0000_0000_0000_0010_1000;//int5 req appear,which has to been masked
#10;
#50;
#10 VICIntSource=22'b00_0000_0000_0000_0010_1001;//higher interrupt int0 req arise
#50;
#10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b0;paddr = 32'hffff_f030;    #10 penable = 1'b1;   bianl=prdata;
#10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;         //read
#100;
#10 VICIntSource=22'b00_0000_0000_0000_0010_1000;//int0 req disappear
#10;
#10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f030;#10 penable = 1'b1;//
#10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000; //serve int0 done,update hardware of VIC and continue to service int3
#10
#100
#10 VICIntSource=22'b00_0000_0000_0000_0010_0000;//int3 req disappear
#10;
#10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f030;#10 penable = 1'b1;
#10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;//serve int3 done,update hardware of VIC and continue to service lower or other ints
#10
#50
#10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b0;paddr = 32'hffff_f030;    #10 penable = 1'b1;   bianl=prdata;
#10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000; //start service int5,and read vectaddr
#100
#10 VICIntSource=22'b00_0000_0000_0000_0000_0000;//int5 req disappear
#10;
#10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b1;paddr = 32'hffff_f030;#10 penable = 1'b1;
#20 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;//serve int5 done,update hardware of VIC and continue to service lower or other ints


#100    //This is FIQ Request and provide no Handler
#10 VICIntSource=22'b00_0000_0000_0000_0000_1000;
#20
#10 VICIntSource=22'b00_0000_0000_0000_0000_0000;

#100    //This is FIQ Request and provide no Handler
#10 VICIntSource=22'b00_0000_0000_0000_1100_0000;
#10 penable = 1'b0;pselVIC = 1'b1;pwrite = 1'b0;paddr = 32'hffff_f030;    #10 penable = 1'b1;   bianl=prdata;
#10 penable = 1'b0;pselVIC = 1'b0;pwrite = 1'b0;paddr = 32'hffff_f000;         //read
#20
#10 VICIntSource=22'b00_0000_0000_0000_0000_0000;


#4000 $stop;

end

always #5 pclk = ~pclk;
//----------------------------------------------------------
// OUTPUT wire definition --- apb_crc
//----------------------------------------------------------
//wire [31:0] prdata;

//----------------------------------------------------------
// Module instantiation --- apb_crc
//----------------------------------------------------------
vic_top    apb_vic_inst (
  .presetn ( presetn ), // I
  .pclk    ( pclk    ), // I
  .pselVIC ( pselVIC ), // I
  .penable ( penable ), // I
  .paddr   ( paddr   ), // I [3:0]
  .pwrite  ( pwrite  ), // I
  .pwdata  ( pwdata  ), // I [31:0]
  .prdata  ( prdata  ),   // O [31:0]
  .VICIntSource ( {{10{1'b0}}, VICIntSource} ), // I [21:0]
  .nvicfiq      ( nvicfiq      ), // O
  .nvicirq      ( nvicirq      )  // O
); // generated by "VLOG_INST"
endmodule
