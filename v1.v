module ModellingCache(operation,inToCache,inputData,outTag0,outTag1,outTag2,outTag3,outValid0,outValid1,outValid2,outValid3,outData0,outData1,outData2,outData3,clk);
//if operation =0 then read and otherwise write
input  operation;

reg[31:0] data0 [0:256];
reg[31:0] data1 [0:256];
reg[31:0] data2 [0:256];
reg[31:0] data3 [0:256];
/////////////////////////
reg[21:0] tag0 [0:256];
reg[21:0] tag1 [0:256];
reg[21:0] tag2 [0:256];
reg[21:0] tag3 [0:256];
/////////////////////////
reg valid0 [0:256];
reg valid1 [0:256];
reg valid2 [0:256];
reg valid3 [0:256];
////////////////////////
input [31:0] inToCache;
output reg [21:0] outTag0,outTag1,outTag2,outTag3;
output reg[31:0] outData0,outData1,outData2,outData3;
output reg outValid0,outValid1,outValid2,outValid3;
input [31:0]inputData;
input clk;


initial
begin

//data0[10]=0;
valid0[10]=0;
//tag0[10]=10;

data1[10]=1000;
valid1[10]=1;
tag1[10]=11;

data2[10]=2000;
valid2[10]=1;
tag2[10]=12;

data3[10]=3000;
valid3[10]=1;
tag3[10]=13;

data0[9]=10000;
valid0[9]=1;
tag0[9]=10;

end



always@(posedge clk)
begin 

if(operation==0)
begin 

outTag0=tag0[inToCache[9:2]];
outTag1=tag1[inToCache[9:2]];
outTag2=tag2[inToCache[9:2]];
outTag3=tag3[inToCache[9:2]];

outData0=data0[inToCache[9:2]];
outData1=data1[inToCache[9:2]];
outData2=data2[inToCache[9:2]];
outData3=data3[inToCache[9:2]];

outValid0=valid0[inToCache[9:2]];
outValid0=valid0[inToCache[9:2]];
outValid0=valid0[inToCache[9:2]];
outValid0=valid0[inToCache[9:2]];

end
else if(operation==1)
begin 
//The second conditions is just for stimulation since initially all variables are x
	if(valid0[inToCache[9:2]]==0||valid0[inToCache[9:2]]==x)
	begin 
	valid0[inToCache[9:2]]=1;
	data0[inToCache[9:2]]=inputData;
	tag0[inToCache[9:2]]=inToCache[31:10];
	end

	else if(valid1[inToCache[9:2]]==0||valid0[inToCache[9:2]]==x)
	begin
	valid1[inToCache[9:2]]=1;
	data1[inToCache[9:2]]=inputData;
	tag1[inToCache[9:2]]=inToCache[31:10];
	end

	else if(valid2[inToCache[9:2]]==0||valid0[inToCache[9:2]]==x)
	begin
	valid2[inToCache[9:2]]=1;
	data2[inToCache[9:2]]=inputData;
	tag2[inToCache[9:2]]=inToCache[31:10];
	end

	else if(valid3[inToCache[9:2]]==0||valid0[inToCache[9:2]]==x)
	begin
	valid3[inToCache[9:2]]=1;
	data3[inToCache[9:2]]=inputData;
	tag3[inToCache[9:2]]=inToCache[31:10];
	end
	//There will be else that will be changed later to the idea of least recently used
	else
	begin
	valid0[inToCache[9:2]]=1;
	data0[inToCache[9:2]]=inputData;
	tag0[inToCache[9:2]]=inToCache[31:10];
	end



end

end



endmodule
/////////////////////////////////////////////////////////////////
module testingCache;

reg clk;
reg [31:0]inToCache;
wire [21:0] outTag0,outTag1,outTag2,outTag3;
wire outValid0,outValid1,outValid2,outValid3;
wire [31:0] outData0,outData1,outData2,outData3;
reg op;
reg[31:0] data;

initial
begin
$monitor($time,,"clk=%d op=%d address=%d outTag0=%d  outData0=%d",clk,op,inToCache,outTag0,outData0);
clk=0;
op=1;
data=15000;
inToCache=10280;

#10
op=0;
inToCache=10280;


#30
$finish;






end

always
begin
#5
clk=~clk;

end
ModellingCache x(op,inToCache,data,outTag0,outTag1,outTag2,outTag3,outValid0,outValid1,outValid2,outValid3,outData0,outData1,outData2,outData3,clk);



endmodule


/////////////////////////////////////////////////////////////////
module FourToOneMux(z,in0,in1,in2,in3,sel);

output reg [0:31] z;
input [31:0] in0,in1,in2,in3;
input [1:0] sel;

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


///////////////////////////////////////////////////////////////////////////////
module InputToMux(x,y,z,w,sel);
//This module takes the four outputs of 4 and gates and outputs a selection to a mux 
output reg [1:0] sel;
input x,y,z,w;

always@(x or y or z or w)
begin
if(x==1&&y==0&&z==0&&w==0)
sel=0;
else if(x==0&&y==1&&z==0&&w==0)
sel=1;
else if(x==0&&y==0&&z==1&&w==0)
sel=2;
else if(x==0&&y==0&&z==0&&w==1)
sel=3;
end


endmodule
////////////////////////////////////////////////////////////////////////////////////////


module Comparator(in1,in2,out);

input wire[21:0] in1,in2;
output reg out;

always@(in1 or in2)
begin

if(in1==in2)
out=1;
else
out=0;

end
endmodule

module tb10;

reg [31:0] in0,in1,in2,in3;
wire [1:0] sel;
wire [31:0] q;
wire x,y,z,w;
//These variables are for testing the comparator instead of the tag in the 4 blocks of the cache 
// coriginal is the tag of the word sent from the processor
//we will compare the tag sent from the processor with tha 4 tags i will generate to stimulate the 4
//blocks of the set associative
reg [21:0] c0,c1,c2,c3,coriginal;
wire  out0,out1,out2,out3;



initial
begin 
$monitor("sel=%d in0=%d in1=%d in2=%d in3=%d out=%d",sel,in0,in1,in2,in3,q);
c0=5050;
c1=5060;
c2=5070;
c3=5080;
coriginal=5080;
in0=1000;
in1=2000;
in2=3000;
in3=4000;

end

Comparator d0(c0,coriginal,out0);
Comparator d1(c1,coriginal,out1);
Comparator d2(c2,coriginal,out2);
Comparator d3(c3,coriginal,out3);
and(x,1,out0);
and(y,1,out1);
and(z,1,out2);
and(w,1,out3);


InputToMux m(x,y,z,w,sel);
FourToOneMux h(q,in0,in1,in2,in3,sel);

endmodule


