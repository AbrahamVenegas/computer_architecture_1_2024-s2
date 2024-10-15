module mainModule(input  logic clk,
	 input logic [3:0] quadrant,
    output logic vga_hsync, vga_vsync, sync_blank, sync_b,clk_25,
    output logic [7:0] red, green, blue);
	 //MODULE FROM WHERE RAM, CPU AND VGA MODULE ARE INSTANTIATED
	 logic [8:0] 	v_offset;
	 logic [8:0]	h_offset;
	 logic [18:0] 	address_b_sig;
	 logic [7:0] 	q_b_sig;
	 ram	ram_inst (
		 .address_a ( 19'b0 ),
		 .address_b ( address_b_sig ),
		 .clock ( clk ),
		 .data_a ( 8'h00 ),
		 .data_b ( 8'h00 ),
		 .wren_a ( 1'h00 ),
		 .wren_b ( 1'h00 ),
		 .q_b ( q_b_sig )
	);
	
	 VGA_Main_Module vga(
		 .clk(clk),
		 .address_b_sig(address_b_sig),
		 .q_b_sig(q_b_sig),
		 .vga_hsync(vga_hsync), 
		 .vga_vsync(vga_vsync), 
		 .sync_blank(sync_blank), 
		 .sync_b(sync_b),
		 .red(red), 
		 .green(green), 
		 .blue(blue),
		 .v_offset(v_offset),
		 .h_offset(h_offset),
		 .clk_25(clk_25)
    );
	 assign h_offset = (quadrant % 4)*100;
	 assign v_offset = ((quadrant-(quadrant % 4))/4)*100;
endmodule