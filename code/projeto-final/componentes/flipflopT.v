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
    output reg [1:0] q
); 

    always @ (posedge clk) begin 
      if (clear)
        q <= 2'b01;
      else
        if(t)
          q <= ~q; 
        else 
          q <= q; 
    end 
endmodule
