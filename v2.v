module  Controller2(op,inputAdd,inputData,outputData);

input op;
input [31:0] inputAdd;
input [31:0] inputData;
output reg [31:0] outputData;
///////////////////////////
//MODELLING CACHE
///////////////////////////
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
/////////////////////////
//MODELLING RAM
/////////////////////////
reg [31:0] data [0:32768];
reg wordAddress;
/////////////////////////
reg [1:0] sel;
reg out0,out1,out2,out3;
reg x,y,z,w,hit;
reg [31:0] outData0,outData1,outData2,outData3;
reg [31:0] output1;
reg [21:0] outTag0,outTag1,outTag2,outTag3;
reg outValid0,outValid1,outValid2,outValid3;
integer k;

always@(posedge clk)
begin

if(op==0)
begin

outTag0=tag0[inputAdd[9:2]];
outTag1=tag1[inputAdd[9:2]];
outTag2=tag2[inputAdd[9:2]];
outTag3=tag3[inputAdd[9:2]];

outData0=data0[inputAdd[9:2]];
outData1=data1[inputAdd[9:2]];
outData2=data2[inputAdd[9:2]];
outData3=data3[inputAdd[9:2]];

outValid0=valid0[inputAdd[9:2]];
outValid1=valid1[inputAdd[9:2]];
outValid2=valid2[inputAdd[9:2]];
outValid3=valid3[inputAdd[9:2]];

if(outTag0==inputAdd[31:10])
out0=1;
else
out0=0;

if(outTag1==inputAdd[31:10])
out1=1;
else
out1=0;

if(outTag2==inputAdd[31:10])
out2=1;
else
out2=0;

if(outTag3==inputAdd[31:10])
out3=1;
else
out3=0;

x= valid0[inputAdd[9:2]] & out0;
y= valid1[inputAdd[9:2]] & out1;
z= valid2[inputAdd[9:2]]& out2;
w= valid3[inputAdd[9:2]]& out3;

hit=(x||y)||(x||w);


if(x==1&&y==0&&z==0&&w==0)
sel=0;
else if(x==0&&y==1&&z==0&&w==0)
sel=1;
else if(x==0&&y==0&&z==1&&w==0)
sel=2;
else if(x==0&&y==0&&z==0&&w==1)
sel=3;

if(sel==0)
	output1=outData0;
else if(sel==1)
	output1=outData1;
else if(sel==2)
	output1=outData2;
else if(sel==3)
	output1=outData3;
else
	output1=32'bx;


if(hit==1)
begin
outputData=output1;
end
else if(hit==0)
begin

if(valid0[inputAdd[9:2]]==0||valid0[inputAdd[9:2]]==1'bx)
	begin 
	tag0[inputAdd[9:2]]=inputAdd[31:10];
	valid0[inputAdd[9:2]]=1;
	data0[inputAdd[9:2]]=data[inputAdd];
	outputData=data[inputAdd];
	end

	else if(valid1[inputAdd[9:2]]==0||valid1[inputAdd[9:2]]==1'bx)
	begin
	tag1[inputAdd[9:2]]=inputAdd[31:10];
	valid1[inputAdd[9:2]]=1;
	data1[inputAdd[9:2]]=data[inputAdd];
	outputData=data[inputAdd];
	end

	else if(valid2[inputAdd[9:2]]==0||valid2[inputAdd[9:2]]==1'bx)
	begin
	tag2[inputAdd[9:2]]=inputAdd[31:10];
	valid2[inputAdd[9:2]]=1;
	data2[inputAdd[9:2]]=data[inputAdd];
	outputData=data[inputAdd];
	end

	else if(valid3[inputAdd[9:2]]==0||valid3[inputAdd[9:2]]==1'bx)
	begin
	tag3[inputAdd[9:2]]=inputAdd[31:10];
	valid3[inputAdd[9:2]]=1;
	data3[inputAdd[9:2]]=data[inputAdd];
	outputData=data[inputAdd];
	end
	//There will be else that will be changed later to the idea of least recently used
	else
	begin
	tag0[inputAdd[9:2]]=inputAdd[31:10];
	valid0[inputAdd[9:2]]=1;
	data0[inputAdd[9:2]]=data[inputAdd];
	outputData=data[inputAdd];
	end






end



end

else if(op==1)
begin
hit=1'bX;
if((valid0[inputAdd[9:2]]==0)||(valid0[inputAdd[9:2]]==1'bx))
	begin 
	tag0[inputAdd[9:2]]=inputAdd[31:10];
	valid0[inputAdd[9:2]]=1;
	data0[inputAdd[9:2]]=inputData;
	data[inputAdd]=inputData;
	outputData=32'bx;
	end

	else if(valid1[inputAdd[9:2]]==0||valid1[inputAdd[9:2]]==1'bx)
	begin
	tag1[inputAdd[9:2]]=inputAdd[31:10];
	valid1[inputAdd[9:2]]=1;
	data1[inputAdd[9:2]]=inputData;
	data[inputAdd]=inputData;
	outputData=32'bx;
	end

	else if(valid2[inputAdd[9:2]]==0||valid2[inputAdd[9:2]]==1'bx)
	begin
	tag2[inputAdd[9:2]]=inputAdd[31:10];
	valid2[inputAdd[9:2]]=1;
	data2[inputAdd[9:2]]=inputData;
	data[inputAdd]=inputData;
	outputData=32'bx;
	end

	else if(valid3[inputAdd[9:2]]==0||valid3[inputAdd[9:2]]==1'bx)
	begin
	tag3[inputAdd[9:2]]=inputAdd[31:10];
	valid3[inputAdd[9:2]]=1;
	data3[inputAdd[9:2]]=inputData;
	data[inputAdd]=inputData;
	outputData=32'bx;
	end
	//There will be else that will be changed later to the idea of least recently used
	/*
	else
	begin
	tag0[inputAdd[9:2]]=inputAdd[31:10];
	valid0[inputAdd[9:2]]=1;
	data0[inputAdd[9:2]]=inputData;
	data[inputAdd]=inputData;
	outputData=32'bx;
	end
	*/
	

end


end

reg clk;
initial
begin
$monitor($time,,"op=%d inputAdd=%d hit=%d outputData=%d clk=%d tag0=%d tag1=%d tag2=%d tag3=%d tag=%d %d",op,inputAdd,hit,outputData,clk,outTag0,outTag1,outTag2,outTag3,inputAdd[31:10],k);
clk=1;



end

always
begin
#2 
clk=~clk;
end







endmodule

module tbbb;

reg op;
reg [31:0] inputData,inputAdd;
wire [31:0] outputData;

initial 
begin




op=1;
inputAdd=64;
inputData=111;
#3
op=1;
inputAdd=1088;
inputData=222;
#3
op=1;
inputAdd=3136;
inputData=333;
#4
op=1;
inputAdd=7232;
inputData=333;

/*
op=1;
inputAdd=2112;
inputData=555;
*/
#4
op=1;
inputAdd=2112;
inputData=5000;
#3
op=0;
inputAdd=2112;
#3
op=0;
inputAdd=2112;
#3



$finish;

end


Controller2 c(op,inputAdd,inputData,outputData);

endmodule

