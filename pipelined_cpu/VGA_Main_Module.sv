module VGA_Main_Module (
    input  logic clk,
	 output logic clk_25,
    output logic vga_hsync, vga_vsync, sync_blank, sync_b,
    output logic [7:0] red, green, blue
    
);

    logic [9:0] 	hs, vs;
	 logic [18:0] 	address_b_sig;
	 logic [7:0] 	q_b_sig;
	 logic wren_a_sig = 0;
	 logic pixel_red_value;
	 logic pixel_green_value;
	 logic pixel_blue_value;
	ram	ram_inst (
	.address_a ( 19'b0 ),
	.address_b ( address_b_sig ),
	.clock ( clk ),
	.data_a ( 8'h00 ),
	.data_b ( 8'h00 ),
	.wren_a ( 1'h00 ),
	.wren_b ( 1'h00 ),
	.q_a ( 1'h00 ),
	.q_b ( q_b_sig )
	);

	 pll vgapll(.inclk(clk), .outclk(clk_25));
	 //Instancia del ImageDrawer
	ImageDrawer imgDrawer(
		.hs(hs),
		.vs(vs),
		.pixel(q_b_sig),
		.memory_addr(address_b_sig),
		.red(red),
		.green(green),
		.blue(blue)
	);
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



