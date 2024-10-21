module TextDrawer (
    input logic clk,
    input logic [9:0] hs,        // Coordenada horizontal
    input logic [9:0] vs,        // Coordenada vertical
    input logic [7:0] text_mem [0:999], // Memorias de texto
    input logic [7:0] text_color [0:999], // Memorias de color
    output logic [7:0] red,
    output logic [7:0] green,
    output logic [7:0] blue
);
    // Definir posición de inicio del texto y tamaño de los caracteres
    parameter X_START = 8;
    parameter Y_START = 8;
    parameter CHAR_WIDTH = 8;
    parameter CHAR_HEIGHT = 8;
    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;
    parameter MAX_CHARS_PER_LINE = 79;
    parameter MAX_LINES = 9;

    logic [9:0] char_x, char_y;
    logic [2:0] bit_x, bit_y;
    logic [7:0] font_data;

    // Calcular la posición del carácter actual
    assign char_x = (hs - X_START) / CHAR_WIDTH;
    assign char_y = (vs - Y_START) / CHAR_HEIGHT;
    assign bit_x = (hs - X_START) % CHAR_WIDTH;
    assign bit_y = (vs - Y_START) % CHAR_HEIGHT;

    // Calcular la dirección de la ROM considerando múltiples líneas
    logic [9:0] actual_char_x;
    logic [9:0] actual_char_y;
    logic [7:0] rom_addr;
    logic [7:0] color_val;

    always_comb begin
        if (char_x < MAX_CHARS_PER_LINE) begin
            actual_char_x = char_x;
            actual_char_y = char_y;
        end else begin
            actual_char_x = char_x % MAX_CHARS_PER_LINE;
            actual_char_y = char_y + (char_x / MAX_CHARS_PER_LINE);
        end

        // Comprobar si se ha llegado al final del texto
        if (text_mem[actual_char_y * MAX_CHARS_PER_LINE + actual_char_x] == 8'h00) begin
            rom_addr = 8'h00;
            color_val = 8'h00;
        end else begin
            rom_addr = text_mem[actual_char_y * MAX_CHARS_PER_LINE + actual_char_x];
            color_val = text_color[actual_char_y * MAX_CHARS_PER_LINE + actual_char_x];
        end
    end

    // Instancia de la ROM de fuente
    FontROM font_rom(.ascii(rom_addr), .row(bit_y), .data(font_data));

    // Definir colores
    logic [7:0] color_red;
    logic [7:0] color_green;
    logic [7:0] color_blue;

    always_comb begin
        case(color_val)
            8'h00: begin // Negro
                color_red = 8'h00;
                color_green = 8'h00;
                color_blue = 8'h00;
            end
            8'h01: begin // Azul
                color_red = 8'h00;
                color_green = 8'hAA;
                color_blue = 8'hFF;
            end
            8'h02: begin // Verde
                color_red = 8'h00;
                color_green = 8'hFF;
                color_blue = 8'h00;
            end
            default: begin // Color por defecto (Naranja)
                color_red = 8'hFF;
                color_green = 8'hAA;
                color_blue = 8'h00;
            end
        endcase
    end

    // Mapear el carácter ASCII a un color basado en text_color
    always_comb begin
        if ((hs >= X_START) && (hs < X_START + SCREEN_WIDTH) && 
            (vs >= Y_START) && (vs < Y_START + SCREEN_HEIGHT)) begin
            if (font_data[bit_x]) begin // Invertir bit_x
                red = color_red;
                green = color_green;
                blue = color_blue;
            end else begin
                red = 8'h00;
                green = 8'h00;
                blue = 8'h00;
            end
        end else begin
            red = 8'h00;
            green = 8'h00;
            blue = 8'h00;
        end
    end
endmodule




















