`timescale 1ns / 1ps

module mainModule_tb;

  // Declare testbench variables
  logic clk;
  logic [3:0] quadrant;
  logic vga_hsync, vga_vsync, sync_blank, sync_b, clk_25;
  logic [7:0] red, green, blue;

  // Instantiate the main module
  mainModule uut (
    .clk(clk),
    .quadrant(quadrant),
    .vga_hsync(vga_hsync),
    .vga_vsync(vga_vsync),
    .sync_blank(sync_blank),
    .sync_b(sync_b),
    .clk_25(clk_25),
    .red(red),
    .green(green),
    .blue(blue)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #10 clk = ~clk; // 50MHz clock (assuming #10 = 20ns period)
  end

  // Test stimulus
  initial begin
    // Initialize inputs
    quadrant = 4'b0000;
    
    // Wait for some time
    #100;

    // Test different quadrants
    quadrant = 4'b0001; // Test with quadrant 1
    #100;

    quadrant = 4'b0010; // Test with quadrant 2
    #100;

    quadrant = 4'b0011; // Test with quadrant 3
    #100;

    quadrant = 4'b0100; // Test with quadrant 4
    #100;

    // Stop the simulation
    $stop;
  end

  // Monitor outputs
  initial begin
    $monitor("Time: %0t | clk: %b | quadrant: %b | vga_hsync: %b | vga_vsync: %b | sync_blank: %b | sync_b: %b | red: %h | green: %h | blue: %h", 
             $time, clk, quadrant, vga_hsync, vga_vsync, sync_blank, sync_b, red, green, blue);
  end

endmodule
