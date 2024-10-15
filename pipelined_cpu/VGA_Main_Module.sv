module VGA_Main_Module (
    input  logic clk,
	 input logic [7:0] 	q_b_sig,
	 input logic [8:0]	v_offset, h_offset,
	 output logic [18:0] 	address_b_sig,
    output logic vga_hsync, vga_vsync, sync_blank, sync_b, clk_25,
    output logic [7:0] red, green, blue
    
);

   logic [9:0] 	hs, vs;
	 
	
	pll vgapll(.inclk(clk), .outclk(clk_25));
	 //Instancia del ImageDrawer
	ImageDrawer imgDrawer(
		.hs(hs),
		.vs(vs),
		.pixel(q_b_sig),
		.memory_addr(address_b_sig),
		.red(red),
		.green(green),
		.blue(blue),
		.v_offset(v_offset),
		.h_offset(h_offset)
	);
	//Instancia del controlador de graficos
	 GraphicsController controller(
        .clk_25(clk_25),
        .vga_hsync(vga_hsync),
        .vga_vsync(vga_vsync),
        .sync_blank(sync_blank),
        .sync_b(sync_b),
        .hs(hs),
        .vs(vs)
    );

	

endmodule



