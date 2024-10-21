module Mux2to1 #(parameter N = 4)(
	input logic sel,
	input logic [N-1:0] In_0,
	input logic [N-1:0]In_1,
	output logic [N-1:0] data_out);
	always_comb begin
		case (sel)
			1'b0: begin
				data_out <= In_0;
			end
			1'b1: begin
				data_out <= In_1;
			end			
		endcase
	end
endmodule