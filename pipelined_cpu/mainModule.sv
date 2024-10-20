module mainModule(input  logic clk,
	 input logic up_btn, down_btn, select_btn,
    output logic vga_hsync, vga_vsync, sync_blank, sync_b,clk_25,
    output logic [7:0] red, green, blue,
	 output logic [6:0] addr_tst_ms, add_tst_ls,
	 output logic			selection_done, mode);
	 logic [18:0] SELECTION_ADDR_DATA_ADDR =19'h30E50;
	 //MODULE FROM WHERE RAM, CPU AND VGA MODULE ARE INSTANTIATED
	 logic [3:0] 	quadrant;
	 //logic 			mode; //zero when selection mode; one when in processing mode
	 logic [8:0] 	v_offset;
	 logic [8:0]	h_offset;
	 logic [18:0] 	address_b_sig;
	 logic [18:0] 	address_a_sig;
	 logic			wren_a_sig;
	 logic [7:0]	data_a_signal;
	 logic [7:0] 	q_b_sig;
	 logic [7:0] 	q_a_sig;
	 logic [18:0]	selection_addr_data;
	 logic [31:0]	selection_addr_data_LE_32bit;
	 logic 			selection_wren;
	 logic			selection_write_mode;
	 
	 logic cpu_wren_signal = 0;
	 logic selection_wren_signal;
	 logic [18:0] cpu_address_signal = 19'h30E50;
	 logic [18:0] selection_address_signal;
	 logic [7:0] cpu_data_a_signal;
	 logic [7:0] selection_data_a_signal;
	 logic prev_up, prev_down;
	 
	 
	 ram	ram_inst (
		 .address_a ( address_a_sig ),
		 .address_b ( address_b_sig ),
		 .clock ( clk ),
		 .data_a ( data_a_signal ),
		 .data_b (8'h00 ),
		 .wren_a ( wren_a_sig ),
		 .wren_b ( 1'h00 ),
		 .q_a(q_a_sig),
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
	 
	 upDownCounter quadrantCounter(
		.clk(clk),
		.reset_n(1),
		.up(~up_btn && prev_up),
		.down(~down_btn && prev_down),
		.count(quadrant)
	 );
	 
	 FSM control(
		.clk(clk),
		.rst(0),
		.next(~select_btn),
		.mode(mode),
		.write(selection_write_mode),
		.write_done(selection_done)
	 );
	 
	 write_32bit_to_ip_ram selection_write(
		.data_in(selection_addr_data_LE_32bit),
		.address(SELECTION_ADDR_DATA_ADDR),
		.write_enable(selection_write_mode),
		.clk(clk),
		.done(selection_done),
		.ram_address(selection_address_signal),
		.ram_writedata(selection_data_a_signal),
		.ram_write_enable(selection_wren_signal)
		
	 );
	 
	 Mux2to1 #(19)ram_address_a_mux(
		.sel(mode),
		.In_0(selection_address_signal),
		.In_1(cpu_address_signal),
		.data_out(address_a_sig)
		);
	 
	 Mux2to1 #(8) ram_writedata_a_mux(
		.sel(mode),
		.In_0(selection_data_a_signal),
		.In_1(cpu_data_a_signal),
		.data_out(data_a_signal)
		);
	 
	 Mux2to1 #(1) ram_write_enables_mux(
		.sel(mode),
		.In_0(selection_wren_signal),
		.In_1(cpu_wren_signal),
		.data_out(wren_a_sig)
		);
	binary_to_7seg bch(
    .binary_in(q_a_sig),  // 8-bit binary input
    .seg_h(addr_tst_ms),      // 7-segment output for higher nibble
    .seg_l(add_tst_ls)       // 7-segment output for lower nibble
);
	always_ff @(posedge clk) begin
		
			prev_up   <= up_btn;
			prev_down <= down_btn;		
	end
	 assign selection_addr_data = h_offset + 400*v_offset;
	 assign h_offset = (quadrant % 4)*100;
	 assign v_offset = ((quadrant-(quadrant % 4))/4)*100;
	 
	 assign selection_addr_data_LE_32bit = {13'b0, selection_addr_data};
endmodule