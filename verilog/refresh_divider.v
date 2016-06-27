module refresh_divider(clock, rclock, clear);

input wire clock;
output reg rclock=0;
output reg clear;

reg[23:0] counter;

localparam toggle = 24'd5000000;

always @(posedge clock)
begin
	if(counter==toggle)
	begin
		rclock<= ~rclock;
		counter<=0;
	end
	else if(counter==0 && rclock==0)
	begin
		clear=1'b1;
		counter<=counter+1;
	end
	else if(counter==1 && rclock==0)
	begin
		clear=1'b0;
		counter<=counter+1;
	end
	else begin
		counter<=counter+1;
	end
end
endmodule