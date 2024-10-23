`timescale 1ns/1ps

module tb_ram_read;

  // Parameters
  parameter ADDR_WIDTH = 19;   // 19 bits for 524,288 addresses
  parameter DATA_WIDTH = 8;    // 8-bit data width
  parameter NUM_ADDRESSES = 160000; // First 160,000 addresses

  // Inputs
  reg [ADDR_WIDTH-1:0] address_a;
  reg clock;

  // Outputs
  wire [DATA_WIDTH-1:0] q_a;

  // Instantiate the Unit Under Test (UUT)
  ram uut (
    .address_a(address_a),
    .address_b(19'b0),  // Unused
    .clock(clock),
    .data_a(8'h00),     // No data input since we're only reading
    .data_b(8'h00),     // Unused
    .wren_a(1'b0),      // Disable write
    .wren_b(1'b0),      // Unused
    .q_a(q_a),
    .q_b()              // Unused
  );

  // Clock generation (50 MHz clock = 20ns period, 10ns half period)
  always #10 clock = ~clock;

  // Testbench logic
  integer i;
  initial begin
    // Initialize inputs
    clock = 0;
    address_a = 0;

    // Wait for global reset
    #10;

    // Loop to read the first 160,000 positions
    for (i = 0; i < NUM_ADDRESSES; i = i + 1) begin
      address_a = i;
      #20;  // Wait for 1 clock cycle (20ns)
      $display("Address: %d, Data: %h", i, q_a); // Display address and data
    end

    // Finish the simulation after reading
    $stop;
  end

endmodule
