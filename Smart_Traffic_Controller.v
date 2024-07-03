`timescale 1ns / 1ps

`define s0 5'd0
`define s1 5'd1
`define s2 5'd2
`define s3 5'd3
`define s4 5'd4
`define s5 5'd5
`define s6 5'd6
`define s7 5'd7
`define s8 5'd8
`define s9 5'd9
`define s10 5'd10
`define s11 5'd11
`define s12 5'd12
`define s13 5'd13
`define s14 5'd14
`define s15 5'd15
`define s16 5'd16
`define s17 5'd17
`define s18 5'd18
`define s19 5'd19
`define s20 5'd20
`define s21 5'd21
`define s22 5'd22
`define s23 5'd23
`define s24 5'd24
`define s25 5'd25
`define s26 5'd26


module Smart_Traffic_Controller(ID,camera,state,next_state,maxTraffic,clock,clear,
a1,a2,a3,b1,b2,b3,c1,c2,c3,d1,d2,d3,ss1,ss2,ss3,ss4,rc1,rc2,rc3,rc4);

input clock,clear,a1,a2,a3,b1,b2,b3,c1,c2,c3,d1,d2,d3,ss1,ss2,ss3,ss4,rc1,rc2,rc3,rc4;
output reg [11:0]ID;    // 12 bit field defining all the traffic lights; for a four crossing level traffic 4 traffic lights are to be 
                        // installed, each traffic light posts will have 3 signals, so 12 bits. 
output reg [5:0]state;    // current state of lights
output reg [5:0]next_state;  // next state depending on various conditions
output reg [2:0]maxTraffic;  // defines which road will get green when in state s1 when all roads are having very less vehicles (like at 5 am morning)
output reg camera;      // captures the traffic rule violation

initial
begin
    ID = 12'b100100100100;
    state = `s0;
    next_state = `s0;
    camera = 0;
end

always@(posedge clock)
begin
    state = next_state;
end

always@(state)
begin
    case(state)
      `s0 : ID = 12'b100100100100;  // Clear State where almost no vehicles
      `s1 : ID = 12'b100100100100;  // slowly traffic builds up
      `s2 : ID = 12'b100100100100;  // maxTraffic builds up for Road A for calculation so all kept red
      `s3 : ID = 12'b100100100100;  // maxTraffic builds up for Road B for calculation so all kept red
      `s4 : ID = 12'b100100100100;  // maxTraffic builds up for Road C for calculation so all kept red
      `s5 : ID = 12'b100100100100;  // maxTraffic builds up for Road D for calculation so all kept red
      `s6 : ID = 12'b001100100100;  // Road A green signal due to max traffic (when sensors a1.a2.a3 = 100)
      `s7 : ID = 12'b001100100100;  // Road A green  (when sensors a1.a2.a3 = 110)
      `s8 : ID = 12'b001100100100;  // Road A green  (when sensors a1.a2.a3 = 111)
      `s9 : ID = 12'b010100100100;  // Road A yellow signal to warn for red because now Road A is having less traffic than other roads
      `s10 : ID = 12'b100001100100; // Road B green signal due to max traffic (when sensors b1.b2.b3 = 100)
      `s11 : ID = 12'b100001100100; // Road B green  (when sensors b1.b2.b3 = 110)
      `s12 : ID = 12'b100001100100; // Road B green  (when sensors b1.b2.b3 = 111)
      `s13 : ID = 12'b100010100100; // Road B yellow signal to warn for red because now Road B is having less traffic than other roads 
      `s14 : ID = 12'b100100001100; // Road C green signal due to max traffic (when sensors c1.c2.c3 = 100)
      `s15 : ID = 12'b100100001100; // Road C green  (when sensors c1.c2.c3 = 110)
      `s16 : ID = 12'b100100001100; // Road C green  (when sensors c1.c2.c3 = 111)
      `s17 : ID = 12'b100100010100; // Road C yellow signal to warn for red because now Road C is having less traffic than other roads 
      `s18 : ID = 12'b100100100001; // Road D green signal due to max traffic (when sensors d1.d2.d3 = 100)
      `s19 : ID = 12'b100100100001; // Road D green  (when sensors d1.d2.d3 = 110)
      `s20 : ID = 12'b100100100001; // Road D green  (when sensors d1.d2.d3 = 111)
      `s21 : ID = 12'b100100100010; // Road D yellow signal to warn for red because now Road D is having less traffic than other roads
      `s22 : ID = 12'b001100100100; // Priority Green for Road A as an emergency vehicle has arrived 
      `s23 : ID = 12'b100001100100; // Priority Green for Road B as an emergency vehicle has arrived 
      `s24 : ID = 12'b100100001100; // Priority Green for Road C as an emergency vehicle has arrived 
      `s25 : ID = 12'b100100100001; // Priority Green for Road D as an emergency vehicle has arrived 
      `s26 : ID = 12'b100100100100; // Transition from S0 to S26 when any of the sound sensors are high
    endcase
end

  always@(state or clear or a1 or a2 or a3 or b1 or b2 or b3 or c1 or c2 or c3 or d1 or d2 or d3 or ss1 or ss2 or ss3 or ss4)
begin
    if(clear)
    next_state = `s0;
    else
    begin
        case(state)
            `s0 : begin
                camera = rc1 || rc2 || rc3 || rc4;
                
                if(ss1 || ss2 || ss3 || ss4)
                next_state = `s26;
                else if(a1 || b1 || c1 || d1)
                next_state = `s1;
                else
                next_state = `s0;
            end
            
            `s1 : begin
                camera = rc1 || rc2 || rc3 || rc4;
                
                calcMaxTraffic(a1,a2,a3,b1,b2,b3,c1,c2,c3,d1,d2,d3,maxTraffic);
                case(maxTraffic)
                    1 : next_state = `s2;
                    2 : next_state = `s3;
                    3 : next_state = `s4;
                    4 : next_state = `s5;
                    default : next_state = `s1;
                 endcase
            end
            
            `s2 : begin
                camera = rc1 || rc2 || rc3 || rc4;
                if(a1 && a2 && a3)
                next_state = `s8;
                else if(a1 && a2 && !a3)
                next_state = `s7;
                else if(a1 && !a2 && !a3)
                next_state = `s6;
            end
            
            `s3 : begin
                camera = rc1 || rc2 || rc3 || rc4;
                if(b1 && b2 && b3)
                next_state = `s12;
                else if(b1 && b2 && !b3)
                next_state = `s11;
                else if(b1 && !b2 && !b3)
                next_state = `s10;
            end
            
            `s4 : begin
                camera = rc1 || rc2 || rc3 || rc4;
                if(c1 && c2 && c3)
                next_state = `s16;
                else if(c1 && c2 && !c3)
                next_state = `s15;
                else if(c1 && !c2 && !c3)
                next_state = `s14;
            end
            
            `s5 : begin
                camera = rc1 || rc2 || rc3 || rc4;
                if(d1 && d2 && d3)
                next_state = `s20;
                else if(d1 && d2 && !d3)
                next_state = `s19;
                else if(d1 && !d2 && !d3)
                next_state = `s18;
            end
            
            `s6 : begin
                camera = rc2 || rc3 || rc4;
                if(ss2 || ss3 || ss4 || !a1 || b2 || c2 || d2)
                next_state = `s9;
                else
                next_state = `s6;
            end
            
            `s7 : begin
                camera = rc2 || rc3 || rc4;
                if((!a1 && !a2) || ss2 || ss3 || ss4 || b2 || c2 || d2)
                next_state = `s9;
                else if(a1 && !a2 && !a3)
                next_state = `s6;
                else
                next_state = `s7;       
            end
            
            `s8 : begin
                camera = rc2 || rc3 || rc4;
                if((!a1 && !a2 && !a3) || ss2 || ss3 || ss4)
                next_state = `s9;
                else if(a1 && a2 && !a3)
                next_state = `s7;
                else if(a1 && !a2 && !a3)
                next_state = `s6;
                else
                next_state = `s8;
            end
            
            `s9 : begin
                camera = rc1 || rc2 || rc3 || rc4;
                next_state = `s0;
            end
            
            `s10 : begin
                camera = rc1 || rc3 || rc4;
                if(ss1 || ss3 || ss4 || a2 || !b1 || c2 || d2)
                next_state = `s13;
                else
                next_state = `s10;
            end
            
            `s11 : begin
                camera = rc1 || rc3 || rc4;
                if((!b1 && !b2) || ss1 || ss3 || ss4 || a3 || c3 || d3)
                next_state = `s13;
                else if(b1 && b2)
                next_state = `s11;
                else if(b1 && !b2)
                next_state = `s10;
            end
            
            `s12 : begin
                camera = rc1 || rc3 || rc4;
                if((!b1 && !b2 && !b3) || ss1 || ss3 || ss4)
                next_state = `s13;
                else if(b1 && b2 && !b3)
                next_state = `s11;
                else if(b1 && !b2 && !b3)
                next_state = `s10;
                else
                next_state = `s12;
            end
            
            `s13 : begin
                camera = rc1 || rc2 || rc3 || rc4;
                next_state = `s0;
            end
            
            `s14 : begin
                camera = rc1 || rc2 || rc4;
                if(ss1 || ss2 || ss4 || a2 || b2 || !c1 || d2)
                next_state = `s17;
                else
                next_state = `s14;
            end
            
            `s15 : begin
                camera = rc1 || rc2 || rc4;
                if((!c1 && !c2) || ss1 || ss2 || ss4 || a3 || b3 || d3)
                next_state = `s17;
                else if(c1 && c2)
                next_state = `s15;
                else if(c1 && !c2)
                next_state = `s14;
            end
            
            `s16 : begin
                camera = rc1 || rc2 || rc4;
                if((!c1 && !c2 && !c3) || ss1 || ss2 || ss4)
                next_state = `s17;
                else if(c1 && c2 && !c3)
                next_state = `s15;
                else if(c1 && !c2 && !c3)
                next_state = `s14;
                else
                next_state = `s16;
            end   
              
             `s17 : begin
                camera = rc1 || rc2 || rc3 || rc4;
                next_state = `s0;
            end 
            
            `s18 : begin
                camera = rc1 || rc2 || rc3;
                if(ss1 || ss2 || ss3 || a2 || b2 || c2 || !d1)
                next_state = `s21;
                else
                next_state = `s18;
            end
            
            `s19 : begin
                camera = rc1 || rc2 || rc3;
                if((!d1 && !d2) || ss1 || ss2 || ss3 || a3 || b3 || d3)
                next_state = `s21;
                else if(d1 && d2)
                next_state = `s19;
                else if(d1 && !d2)
                next_state = `s18;
            end
            
            `s20 : begin
                camera = rc1 || rc2 || rc3;
                if((!d1 && !d2 && !d3) || ss1 || ss2 || ss3)
                next_state = `s21;
                else if(d1 && d2 && !d3)
                next_state = `s19;
                else if(d1 && !d2 && !d3)
                next_state = `s18;
                else
                next_state = `s20;
            end  
            
            `s21 : begin
                camera = rc1 || rc2 || rc3 || rc4;
                next_state = `s0;
            end
            
            `s22 : begin
                camera = rc2 || rc3 || rc4;
                if(ss1)
                next_state = `s22;
                else
                next_state = `s9;
            end
            
            `s23 : begin
                camera = rc1 || rc3 || rc4;
                if(ss2)
                next_state = `s23;
                else
                next_state = `s13;
            end
            
            `s24 : begin
                camera = rc1 || rc2 || rc4;
                if(ss3)
                next_state = `s24;
                else
                next_state = `s17;
            end
            
            `s25 : begin
                camera = rc1 || rc2 || rc3;
                if(ss4)
                next_state = `s25;
                else
                next_state = `s21;
            end
            
            `s26 : begin
                camera = rc1 || rc2 || rc3 || rc4;
                if(ss1)
                next_state = `s22;
                else if(ss2)
                next_state = `s23;
                else if(ss3)
                next_state = `s24;
                else if(ss4)
                next_state = `s25;
            end
            default : next_state = `s0;
      
        endcase
    end
end

task calcMaxTraffic;
    input a1,a2,a3,b1,b2,b3,c1,c2,c3,d1,d2,d3;
    output [2:0]max;
    reg [2:0]a,b,c,d;
    begin
        a = {a3,a2,a1};
        b = {b3,b2,b1};
        c = {c3,c2,c1};
        d = {d3,d2,d1};
        if(a>=b)
        begin
            if(a>=c)
            begin
                if(a>=d)
                    max = 1;
                else
                    max = 4;
            end
            else
            begin
                if(c>=d)
                    max = 3;
                else 
                    max = 4;
            end
        end
        else
        begin
            if(b>=c)
            begin
                if(b>=d)
                    max = 2;
                else
                    max = 4;
            end
            else
            begin
                if(c>=d)
                    max = 3;
                else
                    max = 4;
            end
        end
    end 
endtask

endmodule
