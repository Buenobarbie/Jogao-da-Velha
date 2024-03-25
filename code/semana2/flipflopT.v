/* 
* FLIP-FLOP T
* Troca saída toda vez que 
* há pulso de clock com o 
* sinal T ativo
* Responsavel pela alternancia 
* entre os jogadores 
*/

module flipflop_t (
    input clk, 
    input clear, 
    input t, 
    output reg q
); 

    always @ (posedge clk) begin 
      if (clear)
        q <= 0;
      else
        if(t)
          q <= ~q; 
        else 
          q <= q; 
    end 
endmodule
