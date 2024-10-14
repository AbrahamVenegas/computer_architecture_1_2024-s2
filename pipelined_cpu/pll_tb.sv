`timescale 1ns / 1ps

module pll_tb;

    // Declare inputs as regs and outputs as wires
    reg inclk;
    wire outclk;

    // Instantiate the Unit Under Test (UUT)
    pll uut (
        .inclk(inclk),
        .outclk(outclk)
    );

    // Generate clock signal
    initial begin
        // Initialize inputs
        inclk = 0;
        
        // Toggle inclk every 10 time units
        forever #10 inclk = ~inclk;
    end

    // Monitor changes in signals
    initial begin
        // Display changes in inclk and outclk
        $monitor("Time = %0t | inclk = %b | outclk = %b", $time, inclk, outclk);
        
        // Stop simulation after 100 time units
        #100 $stop;
    end

endmodule
