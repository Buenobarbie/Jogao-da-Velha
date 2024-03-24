module hexa7seg_jogador (jogador, display);
    input      jogador;
    output reg [6:0] display;
    
   /* DISPLAY jogador - mostra de qual jogador é a vez
   * se jogador = 0, display = 1
   * se jogador = 1, display = 2
   */
   
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

    always @ (jogador) 
        case(jogador)
            1'b0:    display = 7'b1111001; // 1
            1'b1:    display = 7'b0100100; // 2

            default: display = 7'b0111111; // -
        endcase
endmodule

