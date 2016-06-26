module snes_clock_divider(clock, sclock);

input wire clock;
output reg sclock=0;

reg[9:0] counter;

localparam toggle = 600;

always @(posedge clock)
begin
	if(counter==600)
	begin
		sclock<= ~sclock;
		counter<=0;
	end
	else begin
		counter<=counter+1;
	end
end
endmodule