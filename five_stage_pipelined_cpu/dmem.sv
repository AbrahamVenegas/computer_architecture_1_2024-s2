module dmem (
    input  logic        clk, we,
    input  logic [31:0] a,  // DataAdr
    input  logic [31:0] wd, // WriteData
    output logic [31:0] rd, // ReadData
    input  logic [3:0]  ByteEn
);
    // Memorias para cada byte
    logic [7:0] ram_3[511:0];  
    logic [7:0] ram_2[511:0];  
    logic [7:0] ram_1[511:0];  
    logic [7:0] ram_0[511:0];  

    // Lógica combinacional para lectura
    always_comb begin
        rd = 32'b0; // Valor por defecto
        case (ByteEn)
            4'b1111: rd = {ram_3[a[31:2]], ram_2[a[31:2]], ram_1[a[31:2]], ram_0[a[31:2]]};
            4'b0001: case (a[1:0])
                        2'b00: rd = {24'b0, ram_0[a[31:2]]};
                        2'b01: rd = {24'b0, ram_1[a[31:2]]};
                        2'b10: rd = {24'b0, ram_2[a[31:2]]};
                        2'b11: rd = {24'b0, ram_3[a[31:2]]};
                     endcase
            4'b1001: case (a[1:0])
                        2'b00: rd = {{24{ram_0[a[31:2]][7]}}, ram_0[a[31:2]]};
                        2'b01: rd = {{24{ram_1[a[31:2]][7]}}, ram_1[a[31:2]]};
                        2'b10: rd = {{24{ram_2[a[31:2]][7]}}, ram_2[a[31:2]]};
                        2'b11: rd = {{24{ram_3[a[31:2]][7]}}, ram_3[a[31:2]]};
                     endcase
            4'b0011: if (a[1] == 1'b0)
                         rd = {16'b0, ram_1[a[31:2]], ram_0[a[31:2]]};
                     else
                         rd = {16'b0, ram_3[a[31:2]], ram_2[a[31:2]]};
            4'b1011: if (a[1] == 1'b0)
                         rd = {{16{ram_1[a[31:2]][7]}}, ram_1[a[31:2]], ram_0[a[31:2]]};
                     else
                         rd = {{16{ram_3[a[31:2]][7]}}, ram_3[a[31:2]], ram_2[a[31:2]]};
        endcase
    end

    // Lógica secuencial para escritura
    always_ff @(posedge clk) begin
        if (we) begin
            case (ByteEn)
                4'b1111: {ram_3[a[31:2]], ram_2[a[31:2]], ram_1[a[31:2]], ram_0[a[31:2]]} <= wd;
                4'b0001: case (a[1:0])
                            2'b00: ram_0[a[31:2]] <= wd[7:0];
                            2'b01: ram_1[a[31:2]] <= wd[7:0];
                            2'b10: ram_2[a[31:2]] <= wd[7:0];
                            2'b11: ram_3[a[31:2]] <= wd[7:0];
                         endcase
                4'b0011: if (a[1] == 1'b0)
                             {ram_1[a[31:2]], ram_0[a[31:2]]} <= wd[15:0];
                         else
                             {ram_3[a[31:2]], ram_2[a[31:2]]} <= wd[15:0];
            endcase
        end
    end
endmodule
