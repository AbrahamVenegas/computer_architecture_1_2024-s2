`timescale 1ns/1ps

module processor_tb;

  // Inputs
  logic clk;
  logic rst;
  logic up_btn;
  logic down_btn;
  logic select_btn;

  // Outputs
  logic vga_hsync;
  logic vga_vsync;
  logic sync_blank;
  logic sync_b;
  logic clk_25;
  logic [7:0] red;
  logic [7:0] green;
  logic [7:0] blue;
  logic [6:0] addr_tst_ms;
  logic [6:0] add_tst_ls;
  logic selection_done;
  logic mode;

  // Clock period for 50 MHz (T = 1 / f = 1 / 50 MHz = 20 ns)
  localparam CLK_PERIOD = 20;

  // Instantiate the DUT (Device Under Test)
  mainModule dut (
    .clk(clk),
    .rst(rst),
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
    .blue(blue),
    .addr_tst_ms(addr_tst_ms),
    .add_tst_ls(add_tst_ls),
    .selection_done(selection_done),
    .mode(mode)
  );

  // Clock generation: 50 MHz
  initial begin
    clk = 0;
    forever #(CLK_PERIOD / 2) clk = ~clk; // Toggle clock every 10 ns
  end

  // Stimulus generation
  initial begin
    // Initialize inputs
    rst = 0;
    up_btn = 0;
    down_btn = 0;
    select_btn = 0;

    // Wait for the clock to stabilize
    #100;
    
    // Release reset after 100 ns
    rst = 1;

    // Run the simulation for a few hundred clock cycles
    #20000;
    
    // End the simulation
    $stop;
  end

endmodule
