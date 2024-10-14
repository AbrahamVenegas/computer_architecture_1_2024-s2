module ImageDrawer(
	input logic [9:0] hs,
	input logic [9:0] vs,
	input logic [7:0] pixel,
	output logic [18:0] memory_addr,
	output logic [7:0] red,
	output logic [7:0] green,
	output logic [7:0] blue
);
	parameter X_START = 0;
   parameter Y_START = 0;
	parameter SCREEN_WIDTH 	= 640;
	parameter SCREEN_HEIGHT = 480;
	parameter IMAGE_1_X		= 0;
	parameter IMAGE_1_Y		= 0;
	parameter IMAGE_2_X		= 439;
	parameter IMAGE_2_Y		= 0;
	
	parameter IMAGE_1_W 		= 400;
	parameter IMAGE_1_H 		= 400;
	parameter IMAGE_2_W 		= 200;
	parameter IMAGE_2_H 		= 200;
	
	always_comb begin
    // Set default values to avoid latches
    memory_addr = 19'd0;
    red = 8'd0;
    green = 8'd0;
    blue = 8'd0;
    
    if ((hs >= X_START) && (hs < X_START + SCREEN_WIDTH) &&
        (vs >= Y_START) && (vs < Y_START + SCREEN_HEIGHT)) begin
        
        // Check for Image 1
        if ((hs >= X_START + IMAGE_1_X) && (hs < X_START + IMAGE_1_W + IMAGE_1_X) &&
            (vs >= Y_START + IMAGE_1_Y) && (vs < Y_START + IMAGE_1_H + IMAGE_1_Y)) begin
            
            memory_addr = (hs - X_START - IMAGE_1_X) + (vs - Y_START - IMAGE_1_Y) * IMAGE_1_W;
            red = pixel;
            green = pixel;
            blue = pixel;
        
        // Check for Image 2 (no overlap with Image 1)
        end else if ((hs >= X_START + IMAGE_2_X) && (hs < X_START + IMAGE_2_W + IMAGE_2_X) &&
                     (vs >= Y_START + IMAGE_2_Y) && (vs < Y_START + IMAGE_2_H + IMAGE_2_Y)) begin
            
            memory_addr = IMAGE_1_W * IMAGE_1_H + (hs - X_START - IMAGE_2_X) + (vs - Y_START - IMAGE_2_Y) * IMAGE_2_W;
            red = pixel;
            green = pixel;
            blue = pixel;
        
        // Outside image regions
        end else begin
            red = 255;
            green = 255;
            blue = 255;
        end
    end
end

	
endmodule