/* 
    Apresenta números de 1 a 9 para 
    indicar o quadrante jogado.
    Caso não seja um quadrante válido, 
    mostra "-" 
*/

module hexa7seg_custom (hexa, display);
    input      [8:0] hexa;
    output reg [6:0] display;

    /*
     *    ---
     *   | 0 |
     * 5 |   | 1
     *   |   |
     *    ---
     *   | 6 |
     * 4 |   | 2
     *   |   |
     *    ---
     *     3
     */
        
    always @(hexa)
    case (hexa)
        9'b000000001:    display = 7'b1111001;
        9'b000000010:    display = 7'b0100100;
        9'b000000100:    display = 7'b0110000;
        9'b000001000:    display = 7'b0011001;
        9'b000010000:    display = 7'b0010010;
        9'b000100000:    display = 7'b0000010;
        9'b001000000:    display = 7'b1111000;
        9'b010000000:    display = 7'b0000000;
        9'b100000000:    display = 7'b0010000;
        
        default: display = 7'b0111111;
    endcase
endmodule
