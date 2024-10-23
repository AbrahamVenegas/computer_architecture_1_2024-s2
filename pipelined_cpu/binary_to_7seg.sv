module binary_to_7seg (
    input  logic [7:0] binary_in,  // 8-bit binary input
    output logic [6:0] seg_h,      // 7-segment output for higher nibble
    output logic [6:0] seg_l       // 7-segment output for lower nibble
);
    
    logic [3:0] high_nibble;  // Upper 4 bits
    logic [3:0] low_nibble;   // Lower 4 bits
    
    // Split the input byte into two nibbles
    assign high_nibble = binary_in[7:4];
    assign low_nibble = binary_in[3:0];
    
    // 7-segment decoder for higher nibble
    always_comb begin
        case (high_nibble)
            4'h0: seg_h = 7'b1000000; // "0"
            4'h1: seg_h = 7'b1111001; // "1"
            4'h2: seg_h = 7'b0100100; // "2"
            4'h3: seg_h = 7'b0110000; // "3"
            4'h4: seg_h = 7'b0011001; // "4"
            4'h5: seg_h = 7'b0010010; // "5"
            4'h6: seg_h = 7'b0000010; // "6"
            4'h7: seg_h = 7'b1111000; // "7"
            4'h8: seg_h = 7'b0000000; // "8"
            4'h9: seg_h = 7'b0010000; // "9"
            4'hA: seg_h = 7'b0001000; // "A"
            4'hB: seg_h = 7'b0000011; // "B"
            4'hC: seg_h = 7'b1000110; // "C"
            4'hD: seg_h = 7'b0100001; // "D"
            4'hE: seg_h = 7'b0000110; // "E"
            4'hF: seg_h = 7'b0001110; // "F"
            default: seg_h = 7'b1111111; // All segments off
        endcase
    end
    
    // 7-segment decoder for lower nibble
    always_comb begin
        case (low_nibble)
            4'h0: seg_l = 7'b1000000; // "0"
            4'h1: seg_l = 7'b1111001; // "1"
            4'h2: seg_l = 7'b0100100; // "2"
            4'h3: seg_l = 7'b0110000; // "3"
            4'h4: seg_l = 7'b0011001; // "4"
            4'h5: seg_l = 7'b0010010; // "5"
            4'h6: seg_l = 7'b0000010; // "6"
            4'h7: seg_l = 7'b1111000; // "7"
            4'h8: seg_l = 7'b0000000; // "8"
            4'h9: seg_l = 7'b0010000; // "9"
            4'hA: seg_l = 7'b0001000; // "A"
            4'hB: seg_l = 7'b0000011; // "B"
            4'hC: seg_l = 7'b1000110; // "C"
            4'hD: seg_l = 7'b0100001; // "D"
            4'hE: seg_l = 7'b0000110; // "E"
            4'hF: seg_l = 7'b0001110; // "F"
            default: seg_l = 7'b1111111; // All segments off
        endcase
    end
    
endmodule
