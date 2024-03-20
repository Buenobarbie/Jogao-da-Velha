module hexa7seg_J (habilita_J, J);
    input      habilita_J;
    output reg [6:0] J;
    
   /* DISPLAY J - mostra a letra J 
   * input habilita_J deve ser 1'b1 no circuito
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

    always @ (habilita_J) begin
        if(habilita_J) J = 7'b1100001; // J 
        else J = 7'b0111111; // - 
    end
endmodule
