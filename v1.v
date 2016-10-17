module ModellingMemory;

reg[7:0] A [0:256];

endmodule

module TestingMemory;
ModellingMemory x();
initial
begin
	x.A[0]=20;
	$display("%b",x.A[0]);
end

endmodule

module FourToOneMux(z,in0,in1,in2,in3,sel);

output reg [0:31] z;
input [0:31] in0,in1,in2,in3;
input [0:1] sel;

always@(in0 or in1 or in2 or in3 or sel)
begin 
	if(sel==0)
	z=in0;
	else if(sel==1)
	z=in1;
	else if(sel==2)
	z=in2;
	else if(sel==3)
	z=in3;
	else
	z=32'bx;
end


endmodule



module InputToMux(x,y,z,w,sel);
//This module takes the four outputs of 4 and gates and outputs a selection to a mux 
output reg [0:1] sel;
input x,y,z,w;

always@(x or y or z or w)
begin
if(x==1&&y==0&&z==0&&w==0)
sel=3;
else if(x==0&&y==1&&z==0&&w==0)
sel=2;
else if(x==0&&y==0&&z==1&&w==0)
sel=1;
else if(x==0&&y==0&&z==0&&w==1)
sel=0;
end


endmodule

module tb10;

reg [0:31] in0,in1,in2,in3;
wire [0:1] sel;
wire [0:31] q;
reg x,y,z,w;

initial
begin 
$monitor("sel=%d in0=%d in1=%d in2=%d in3=%d out=%d",sel,in0,in1,in2,in3,q);
	
#5
x=1;
y=0; z=0; w=0;
in0=50;
in1=100;
in2=500;
in3=2300;
#5
x=0;
y=1;
#5
y=0;
z=1;
end

InputToMux m(x,y,z,w,sel);
FourToOneMux h(q,in0,in1,in2,in3,sel);

endmodule


