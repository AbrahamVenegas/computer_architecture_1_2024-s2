`timescale 1ns / 1ps

module mainModule_tb;

  // Testbench signals
  logic clk;
  logic up_btn, down_btn, select_btn;
  logic vga_hsync, vga_vsync, sync_blank, sync_b, clk_25;
  logic [7:0] red, green, blue;
  
  // Instantiate the mainModule
  mainModule uut (
    .clk(clk),
    .up_btn(up_btn),
    .down_btn(down_btn),
    .select_btn(select_btn),
    .vga_hsync(vga_hsync),
    .vga_vsync(vga_vsync),
    .sync_blank(sync_blank),
    .sync_b(sync_b),
    .clk_25(clk_25),
    .red(red),
    .green(green),
    .blue(blue)
  );
  
  // Clock generation for 50 MHz
  always #10 clk = ~clk;  // 50 MHz clock
  
  initial begin
    // Initialize inputs
    clk = 0;
    up_btn = 1;
    down_btn = 1;
    select_btn = 1;
    
    // Push and release up_btn
    #20 up_btn = 0;  // Press up button
    #20 up_btn = 1;  // Release up button
    
    // Push and release select_btn
    #40 select_btn = 0;  // Press select button
    #20 select_btn = 1;  // Release select button
    // Push and release select_btn
    #40 select_btn = 0;  // Press select button
    #20 select_btn = 1;  // Release select button
	 // Push and release select_btn
    #40 select_btn = 0;  // Press select button
    #20 select_btn = 1;  // Release select button
    // Observe the outputs
    #100;
    
    // End simulation
    $stop;
  end

  // Monitor outputs
  initial begin
    $monitor("Time: %0d, up_btn: %b, select_btn: %b, red: %h, green: %h, blue: %h",
             $time, up_btn, select_btn, red, green, blue);
  end
endmodule
