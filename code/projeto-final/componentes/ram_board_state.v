/* 
* Este módulo é uma memória ram para representar o estado do tabuleiro macro.
* Ela tem 10 céluals (apenas as de 1 a 9 são usadas) de 2 bits cada 10x2
* O valor armazenado singifica o estado da macro célula:
* 00 - Em andamento
* 01 - Jogador 1 ganhou
* 10 - Jogador 2 ganhou
* 11 - Empate
*
* Sua saída indica o ganhador final do jogo:
* 00 - Em andamento
* 01 - Jogador 1 ganhou
* 10 - Jogador 2 ganhou
* 11 - Empate
*/


module ram_board_state 
(
    input        clk,
    input        clear,
    input        we,
    input  [1:0] data,
    input  [3:0] addr,
    output [1:0] state_final,
    output [1:0] Q
);

    // Variavel RAM (armazena dados)
    reg [1:0] ram [9:0];
    reg [1:0] ram_aux [9:0];

    // Registra endereco de acesso
    reg [3:0] addr_reg;

    reg jogador1_ganhou;
    reg jogador2_ganhou;
    reg empate;

    initial 
    begin : INICIA_RAM
 
     ram[0] <= 2'b00;
     ram[1] <= 2'b00;
     ram[2] <= 2'b00;
     ram[3] <= 2'b00;
     ram[4] <= 2'b00;
     ram[5] <= 2'b00;
     ram[6] <= 2'b00;
     ram[7] <= 2'b00;
     ram[8] <= 2'b00;
     ram[9] <= 2'b00;

    end 

    always @ (posedge clk or posedge clear )
    begin
        // Escrita da memoria
        if (clear) begin
            ram[0] <= 2'b00;
            ram[1] <= 2'b00;
            ram[2] <= 2'b00;
            ram[3] <= 2'b00;
            ram[4] <= 2'b00;
            ram[5] <= 2'b00;
            ram[6] <= 2'b00;
            ram[7] <= 2'b00;
            ram[8] <= 2'b00;
            ram[9] <= 2'b00;

        end
        else if (we)
            ram[addr] <= data;


        jogador1_ganhou <= ((ram[1][0] && !ram[1][1]) && (ram[2][0] && !ram[2][1]) && (ram[3][0] && !ram[3][1])) ||
                           ((ram[4][0] && !ram[4][1]) && (ram[5][0] && !ram[5][1]) && (ram[6][0] && !ram[6][1])) ||
                           ((ram[7][0] && !ram[7][1]) && (ram[8][0] && !ram[8][1]) && (ram[9][0] && !ram[9][1])) ||
                           ((ram[1][0] && !ram[1][1]) && (ram[4][0] && !ram[4][1]) && (ram[7][0] && !ram[7][1])) ||
                           ((ram[2][0] && !ram[2][1]) && (ram[5][0] && !ram[5][1]) && (ram[8][0] && !ram[8][1])) ||
                           ((ram[3][0] && !ram[3][1]) && (ram[6][0] && !ram[6][1]) && (ram[9][0] && !ram[9][1])) ||
                           ((ram[1][0] && !ram[1][1]) && (ram[5][0] && !ram[5][1]) && (ram[9][0] && !ram[9][1])) ||
                           ((ram[3][0] && !ram[3][1]) && (ram[5][0] && !ram[5][1]) && (ram[7][0] && !ram[7][1]));
        
        jogador2_ganhou <= ((!ram[1][0] && ram[1][1]) && (!ram[2][0] && ram[2][1]) && (!ram[3][0] && ram[3][1])) ||
                           ((!ram[4][0] && ram[4][1]) && (!ram[5][0] && ram[5][1]) && (!ram[6][0] && ram[6][1])) ||
                           ((!ram[7][0] && ram[7][1]) && (!ram[8][0] && ram[8][1]) && (!ram[9][0] && ram[9][1])) ||
                           ((!ram[1][0] && ram[1][1]) && (!ram[4][0] && ram[4][1]) && (!ram[7][0] && ram[7][1])) ||
                           ((!ram[2][0] && ram[2][1]) && (!ram[5][0] && ram[5][1]) && (!ram[8][0] && ram[8][1])) ||
                           ((!ram[3][0] && ram[3][1]) && (!ram[6][0] && ram[6][1]) && (!ram[9][0] && ram[9][1])) ||
                           ((!ram[1][0] && ram[1][1]) && (!ram[5][0] && ram[5][1]) && (!ram[9][0] && ram[9][1])) ||
                           ((!ram[3][0] && ram[3][1]) && (!ram[5][0] && ram[5][1]) && (!ram[7][0] && ram[7][1]));
                            
        empate <=          (ram[1][0] || ram[1][1]) && (ram[2][0] || ram[2][1]) && (ram[3][0] || ram[3][1]) &&
                           (ram[4][0] || ram[4][1]) && (ram[5][0] || ram[5][1]) && (ram[6][0] || ram[6][1]) &&
                           (ram[7][0] || ram[7][1]) && (ram[8][0] || ram[8][1]) && (ram[9][0] || ram[9][1]);

        addr_reg <= addr;
    end
    
    // Update state
    assign state_final = (jogador1_ganhou || jogador2_ganhou) ? {jogador2_ganhou, jogador1_ganhou} :
                                                                {empate, empate};
    assign Q = ram[addr_reg];

endmodule
