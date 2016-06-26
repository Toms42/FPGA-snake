module snake(screenX, screenY, refresh, vga_clock, r, g ,b, up_in, down_in, left_in, right_in);

// io:
input vga_clock;
input[9:0] screenX;
input[8:0] screenY;
input refresh;

input up_in, down_in, left_in, right_in;

wire vga_clock;
wire[9:0] screenX;
wire[8:0] screenY;
wire refresh;

wire up_in, down_in, left_in, right_in;

output[3:0] r;
output[3:0] g;
output[3:0] b;

reg[3:0] r;
reg[3:0] g;
reg[3:0] b;

//local variables:

localparam width = 30;
localparam height = 22;

reg[9:0] snakeCounters[0:height-1][0:width-1];

reg[2:0] direction;
localparam[2:0] up = 3'd0;
localparam[2:0] down = 3'd1;
localparam[2:0] left = 3'd2;
localparam[2:0] right = 3'd3;

reg[4:0] foodX;
reg[4:0] foodY;

reg[9:0] length=10'd5;

reg[4:0] headX=5'd15;
reg[4:0] headY=5'd10;

reg dead=1'b0;

reg[4:0] x=0;
reg[4:0] y=0;

//move snake:
always @(posedge refresh)
begin

	for(x=0;x<width;x=x+1)
	begin
		for(y=0;y<height;y=y+1)
		begin
			if(snakeCounters[y][x]>0)
				snakeCounters[y][x]<=snakeCounters[y][x]-1;
		end
	end

	case (direction)
		up:
		begin
			snakeCounters[headY-1][headX]<=length;
			headY<=headY-1;
		end

		down:
		begin
			snakeCounters[headY+1][headX]<=length;
			headY<=headY+1;
		end

		left:
		begin
			snakeCounters[headY][headX-1]<=length;
			headX<=headX-1;
		end

		right:
		begin
			snakeCounters[headY][headX+1]<=length;
			headX<=headX+1;
		end
	endcase

end

//update direction:
always @(posedge refresh)
begin
	if(up_in==1)
		direction<=up;

	else if(down_in==1)
		direction<=down;

	else if(left_in==1)
		direction<=left;

	else if(right_in==1)
		direction<=right;
end

//draw snake stuff:
always @(posedge vga_clock)
begin
	if(screenX>20 && screenX<620 && screenY>20 && screenY<460)
	begin
		b=4'b0000;
		if(snakeCounters[(screenY-20)/height][(screenY-20)screenX/width]>0)
		begin
			g=4'b1111;
		end
		else begin
			g=4'b0000;
		end
	end
	else begin
		b=4'b1111;
	end
end
endmodule