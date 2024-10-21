module pll(
	input logic inclk,
	output logic outclk
);
	logic toggle = 0;
	
	
	always_ff @(posedge inclk) begin
		toggle <= ~toggle;
	end
	assign outclk = toggle;
endmodule