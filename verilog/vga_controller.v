module vga_controller (clk, h_sync, v_sync, r, g, b, screenX, screenY, rin, gin, bin);

input clk;//this must be 25MHz
input[3:0] rin, gin, bin;
output h_sync;
output v_sync;
output[3:0] r;
output[3:0] g;
output[3:0] b;
output[9:0] screenX;
output[8:0] screenY;

wire clk;
wire[3:0] rin, gin, bin;
wire[9:0] screenX;
wire[8:0] screenY;
wire in_screen_zone;

reg[9:0] counterH;
reg[9:0] counterV;
wire[3:0] r;
wire[3:0] g;
wire[3:0] b;
reg h_sync;
reg v_sync;

/*horizontal timing parameters: (in pixel clocks)
 *
 * Sync: 96
 * Back Porch: 48
 * display interval: 640
 * front porch: 16
 *
 * parameters are the *last* clock cycle of each section
 */

localparam[9:0] hs = 96;
localparam[9:0] hbp = 144;
localparam[9:0] hd = 784;
localparam[9:0] hfp = 800;

/*vertical timing paraneters: (in lines)
 *
 * Sync: 2
 * Back Porch: 33
 * display interval: 480
 * front porch: 10
 *
 * parameters are the *last* line of each section
 */

localparam[9:0] vs = 2;
localparam[9:0] vbp = 35;
localparam[9:0] vd = 515;
localparam[9:0] vfp = 525;

//assigns:

assign screenX = in_screen_zone ? counterH-hbp-1 : 0;
assign screenY = in_screen_zone ? counterV-vbp-1: 0;

assign r = in_screen_zone ? rin : 4'b0;
assign g = in_screen_zone ? gin : 4'b0;
assign b = in_screen_zone ? bin : 4'b0;

assign in_screen_zone = (counterH>hbp && counterV>vbp) ? 1'b1 : 1'b0;

//generate counter values:
always @(posedge clk)
begin
	if(counterH==hfp)
	begin
		counterH<=0;
		if(counterV==vfp)
		begin
			counterV<=0;
		end
		else begin
			counterV<=counterV+1;
		end
	end
	else begin
		counterH<=counterH+1;
	end
end

//generate sync signals:
always @(posedge clk)
begin
	h_sync <= (counterH>=hs);
	v_sync <= (counterV>=vs);
end

//generate pixel bars for testing:
/*
always @(posedge clk)
begin
	if(counterH>hbp && counterH<hbp+213)
	begin
		r<=4'b1111;
	end
	else begin
		r<=0;
	end

	if(counterH>=hbp+213 && counterH<hbp+213+213)
	begin
		g<=4'b1111;
	end
	else begin
		g<=0;
	end

	if(counterH>=hbp+213+213 && counterH<hd)
	begin
		b<=4'b1111;
	end
	else begin
		b<=0;
	end
end
*/

endmodule