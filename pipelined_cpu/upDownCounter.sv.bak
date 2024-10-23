module upDownCounter (
    input logic clk,        // Clock signal
    input logic reset_n,    // Asynchronous active-low reset
    input logic up,         // Up counting mode signal
    input logic down,       // Down counting mode signal
    output logic [3:0] count // 4-bit counter output
);

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            count <= 4'b0000; // Reset counter to 0
        else begin
            if (up && !down)      // Count up if up signal is high and down is low
                count <= count + 1;
            else if (down && !up) // Count down if down signal is high and up is low
                count <= count - 1;
        end
    end

endmodule
