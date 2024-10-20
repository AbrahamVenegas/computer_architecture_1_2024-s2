module write_32bit_to_ip_ram (
    input logic [31:0] data_in,         // 32-bit input data
    input logic [18:0] address,         // 19-bit base address
    input logic write_enable,           // Enable write operation
    input logic clk,                    // Clock signal
    output logic done,                    // Write complete flag
	 output logic [18:0] ram_address,
	 output logic [7:0]  ram_writedata,
	 output logic 			ram_write_enable
);
	
    logic [1:0] byte_counter = 0;    // Byte counter (to keep track of 4 bytes)
    always @(posedge clk) begin
        if (write_enable) begin
            case (byte_counter)
                2'b00: begin
                    ram_address     <= address;            // Write to base address
                    ram_writedata   <= data_in[7:0];       // Write lowest 8 bits
                    ram_write_enable <= 1'b1;
                    byte_counter    <= 2'b01;
                end
                2'b01: begin
                    ram_address     <= address + 1;        // Write to base+1
                    ram_writedata   <= data_in[15:8];      // Write next 8 bits
                    ram_write_enable <= 1'b1;
                    byte_counter    <= 2'b10;
                end
                2'b10: begin
                    ram_address     <= address + 2;        // Write to base+2
                    ram_writedata   <= data_in[23:16];     // Write next 8 bits
                    ram_write_enable <= 1'b1;
                    byte_counter    <= 2'b11;
                end
                2'b11: begin
                    ram_address     <= address + 3;        // Write to base+3
                    ram_writedata   <= data_in[31:24];     // Write highest 8 bits
                    ram_write_enable <= 1'b1;
                    byte_counter    <= 2'b00;              // Reset counter
                    done            <= 1'b1;               // Set done flag
                end
            endcase
        end else begin
            ram_write_enable <= 1'b0;  // Disable write when not active
            done <= 1'b0;              // Clear done flag
        end
    end
endmodule
