/* 
* Este módulo é uma memória ram para representar o estado do tabuleiro .
* Ela tem 10 céluals (macro) com 10 células cada (micro) de 2 bits cada 10x10x2
* O valor armazenado singifica a jogada armazenda da micro célula:
* 00 - Sem jogada
* 01 - Jogador 1
* 10 - Jogador 2 
*
* Sua saída indica o ganhador da célula macro (addr_macro): 
* 00 - Em andamento
* 01 - Jogador 1 ganhou
* 10 - Jogador 2 ganhou
* 11 - Empate
*/


module ram_board
(
    input        clk,
    input        clear,
    input        we,
    input  [1:0] data,
    input  [3:0] addr_macro,
    input  [3:0] addr_micro,
    output [1:0] q,
    output [1:0] state
);

    // Variavel RAM (armazena dados)
    // valor      macro micro
    reg [1:0] ram [9:0][9:0];

    // Registra endereco de acesso
    reg [3:0] addr_reg_macro;
    reg [3:0] addr_reg_micro;

    reg jogador1_ganhou;
    reg jogador2_ganhou;
    reg empate;

    // initial 
    // begin : INICIA_RAM

    integer i, j;

    // for(i=0; i<10; i=i+1) begin
    //     for(j=0; j<10; j=j+1) begin
    //         ram[i][j] <= 2'b00;
    //     end
    // end
        // end 



    always @ (posedge clk or posedge clear)
    begin
        if (clear) begin
            // integer i, j;

            for(i=0; i<10; i=i+1) begin
                for(j=0; j<10; j=j+1) begin
                    ram[i][j] <= 2'b00;
                end
            end
        end

        // Escrita da memoria
        else if (we)
            ram[addr_macro][addr_micro] <= data;
        // 01
        // 01 01 01
        // 10 01 10
        // 10 10 
        jogador1_ganhou <= (ram[addr_macro][1][0] && ram[addr_macro][2][0] && ram[addr_macro][3][0]) ||
                           (ram[addr_macro][4][0] && ram[addr_macro][5][0] && ram[addr_macro][6][0]) ||
                           (ram[addr_macro][7][0] && ram[addr_macro][8][0] && ram[addr_macro][9][0]) ||
                           (ram[addr_macro][1][0] && ram[addr_macro][4][0] && ram[addr_macro][7][0]) ||
                           (ram[addr_macro][2][0] && ram[addr_macro][5][0] && ram[addr_macro][8][0]) ||
                           (ram[addr_macro][3][0] && ram[addr_macro][6][0] && ram[addr_macro][9][0]) ||
                           (ram[addr_macro][1][0] && ram[addr_macro][5][0] && ram[addr_macro][9][0]) ||
                           (ram[addr_macro][3][0] && ram[addr_macro][5][0] && ram[addr_macro][7][0]);

        jogador2_ganhou <= (ram[addr_macro][1][1] && ram[addr_macro][2][1] && ram[addr_macro][3][1]) ||
                           (ram[addr_macro][4][1] && ram[addr_macro][5][1] && ram[addr_macro][6][1]) ||
                           (ram[addr_macro][7][1] && ram[addr_macro][8][1] && ram[addr_macro][9][1]) ||
                           (ram[addr_macro][1][1] && ram[addr_macro][4][1] && ram[addr_macro][7][1]) ||
                           (ram[addr_macro][2][1] && ram[addr_macro][5][1] && ram[addr_macro][8][1]) ||
                           (ram[addr_macro][3][1] && ram[addr_macro][6][1] && ram[addr_macro][9][1]) ||
                           (ram[addr_macro][1][1] && ram[addr_macro][5][1] && ram[addr_macro][9][1]) ||
                           (ram[addr_macro][3][1] && ram[addr_macro][5][1] && ram[addr_macro][7][1]);
        
        empate <=     (ram[addr_macro][1][0] || ram[addr_macro][1][1]) &&
                      (ram[addr_macro][2][0] || ram[addr_macro][2][1]) &&
                      (ram[addr_macro][3][0] || ram[addr_macro][3][1]) &&
                      (ram[addr_macro][4][0] || ram[addr_macro][4][1]) &&
                      (ram[addr_macro][5][0] || ram[addr_macro][5][1]) &&
                      (ram[addr_macro][6][0] || ram[addr_macro][6][1]) &&
                      (ram[addr_macro][7][0] || ram[addr_macro][7][1]) &&
                      (ram[addr_macro][8][0] || ram[addr_macro][8][1]) &&
                      (ram[addr_macro][9][0] || ram[addr_macro][9][1]);

        
        addr_reg_macro <= addr_macro;
        addr_reg_micro <= addr_micro;

    end

    // Atribuicao continua retorna dado
    assign q = ram[addr_reg_macro][addr_reg_micro];

    // Atualizar o state
    assign state = (jogador1_ganhou || jogador2_ganhou) ? {jogador2_ganhou, jogador1_ganhou} :
                                                          {empate, empate};


endmodule
