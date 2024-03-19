// Esse módulo converte a entrada dos
// botões para o binário correspondente, de 1 a 9
module conversor (
    input      [8:0] botoes,
    output reg [3:0] binario
);

    always @(botoes)
    case (botoes)
        9'b000000001:    binario = 4'b0001;
        9'b000000010:    binario = 4'b0010;
        9'b000000100:    binario = 4'b0011;
        9'b000001000:    binario = 4'b0100;
        9'b000010000:    binario = 4'b0101;
        9'b000100000:    binario = 4'b0110;
        9'b001000000:    binario = 4'b0111;
        9'b010000000:    binario = 4'b1000;
        9'b100000000:    binario = 4'b1001;
     
        default: binario = 4'b0000;
    endcase

endmodule
