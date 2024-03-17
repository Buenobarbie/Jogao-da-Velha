/* 
* Este módulo é uma memória ram para representar o estado do tabuleiro macro.
* Ela tem 10 céluals (apenas as de 1 a 9 são usadas) de 2 bits cada 10x2
* O valor armazenado singifica o estado da macro célula:
* 00 - Em andamento
* 01 - Jogador 1 ganhou
* 10 - Jogador 2 ganhou
* 11 - Empate
*
* Alguns valores já são inicializados para testes
*/


module ram_board_state 
(
    input        clk,
    input        we,
    input  [1:0] data,
    input  [3:0] addr,
    output [1:0] q
);

    // Variavel RAM (armazena dados)
    reg [1:0] ram [9:0];

    // Registra endereco de acesso
    reg [3:0] addr_reg;

    initial 
    begin : INICIA_RAM
 
     ram[0] <= 2'b00;
     ram[1] <= 2'b00;
     ram[2] <= 2'b01;
     ram[3] <= 2'b00;
     ram[4] <= 2'b00;
     ram[5] <= 2'b10;
     ram[6] <= 2'b00;
     ram[7] <= 2'b11;
     ram[8] <= 2'b00;
     ram[9] <= 2'b00;

    end 

    always @ (posedge clk)
    begin
        // Escrita da memoria
        if (we)
            ram[addr] <= data;

        addr_reg <= addr;
    end

    // Atribuicao continua retorna dado
    assign q = ram[addr_reg];

endmodule