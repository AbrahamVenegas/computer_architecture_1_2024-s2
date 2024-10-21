module FSM(
	input logic clk, rst, next, write_done,
	output logic mode,
	output logic write
);

	logic [1:0] state, next_state;
	logic prev_next;
	
	//edge detection for 'next' signal
	always_ff @(posedge clk, posedge rst) begin
		if(rst) begin
			prev_next <=2'b0;
		end else begin
			prev_next <= next;
		end
	end
	
	always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
			state <= 2'b00;
		end else begin
			state <= next_state;
		end
	end
	
	always_comb begin
		next_state = state;
		case (state)
			0: next_state = 1;
			1: if(next && !prev_next) next_state = 2; else next_state = 1;
			2: if(next && !prev_next && write_done) next_state = 3; else next_state = 2;
			3: next_state = 3;
			default: next_state = 0;
		endcase
	end
	
	assign mode 	= (state == 3);
	assign write 	= (state == 2);
endmodule