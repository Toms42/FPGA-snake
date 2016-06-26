module snes_input (clock,
				up, down, left, right,
				a, b, x, y,
				start, sel,
				l, r,
				dclock, dlatch, data);
//ports:
input clock;//41.667kHz
input data;

output up, down, left, right;
output a, b, x, y;
output start, sel;
output l, r;
output dclock, dlatch;

//port type declarations:
wire clock;

reg up, down, left, right;
reg a, b, x, y;
reg start, sel;
reg l, r;

wire dlatch;
wire dclock;

//states:
reg[1:0] state;
reg[3:0] data_index;

localparam idle=0;
localparam latching = 1;
localparam reading = 2;

//assigns:
assign dclock = (state==reading) ? clock : 1'b1;
assign dlatch = (state==latching) ? 1'b1 : 1'b0;

//do idle:
always@(posedge clock)
begin
	if(state==idle)
		state<=latching;
	else if (state==latching)
	begin
		state<=reading;
	end
	else if(state==reading)
	begin
		if(data_index==15)
			state<=idle;
	end
end

//do reading stuff

always@(negedge clock)
begin
	if(state==idle)
	begin
		data_index=4'b0;
	end
	else if(state==reading)
	begin
		case (data_index)
		0: b<= ~data;
		1: y<= ~data;
		2: sel<= ~data;
		3: start<= ~data;
		4: up<= ~data;
		5: down<= ~data;
		6: left<= ~data;
		7: right<= ~data;
		8: a<= ~data;
		9: x<= ~data;
		10: l<= ~data;
		11: r<= ~data;
		12: right<= ~data;
		endcase
		data_index<=data_index+1;
	end
end

endmodule