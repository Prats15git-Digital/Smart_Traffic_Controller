`timescale 1ns / 1ps

module Smart_Traffic_Controller_tb();

reg clock,clear,a1,a2,a3,b1,b2,b3,c1,c2,c3,d1,d2,d3,ss1,ss2,ss3,ss4,rc1,rc2,rc3,rc4;
wire [11:0]ID;
wire [5:0]state;
wire [5:0]next_state;
wire [2:0]maxTraffic;
wire camera;

Smart_Traffic_Controller DUT(.ID(ID),.camera(camera),.state(state),.next_state(next_state),.maxTraffic(maxTraffic),.clock(clock),.clear(clear),
.a1(a1),.a2(a2),.a3(a3),.b1(b1),.b2(b2),.b3(b3),.c1(c1),.c2(c2),.c3(c3),.d1(d1),.d2(d2),.d3(d3),.ss1(ss1),.ss2(ss2),.ss3(ss3),.ss4(ss4),.rc1(rc1),.rc2(rc2),.rc3(rc3),.rc4(rc4));

initial
begin
    clock = 1'b0;
    clear=0;a1=0;a2=0;a3=0;b1=1;b2=1;b3=0;c1=0;c2=0;c3=0;d1=1;d2=0;d3=0;ss1=0;ss2=0;ss3=0;ss4=0;rc1=0;rc2=0;rc3=0;rc4=0;
end

always
begin
    #1 clock <= ~clock;
end

initial
begin

   #5 rc4 = 1;
   #5 rc4 = 0; b1 = 0; b2 = 0;
   #10 a1 = 1;
   #5 d1 = 0;
   #10 ss2 = 1;
   #5 ss2 = 0;
   #10 a1 = 0;
    
end

endmodule
