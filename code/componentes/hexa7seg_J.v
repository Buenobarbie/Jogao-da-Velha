module hexa7seg_J (habilita_J, J);
    input      habilita_J;
    output reg [6:0] J;
    
   /* DISPLAY J - mostra a letra J 
   * input habilita_J deve ser 1'b1 no circuito
   */

    always @ (habilita_J) begin
        if(habilita_J) J = 7'b0001110; // J 
        else J = 7'b0111111; // - 
    end
endmodule
