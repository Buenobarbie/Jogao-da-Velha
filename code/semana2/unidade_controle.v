
module unidade_controle (
    input      clock,
    input      reset,
    input      iniciar,
    input      tem_jogada,
    input      fim_jogo,
    input      escolhe_macro,
    output reg sinal_macro,
    output reg troca_jogador,
    output reg zeraR_macro,
    output reg zeraR_micro,
    output reg zeraEdge,
    output reg registraR_macro,
    output reg registraR_micro,
    output reg pronto,
    output reg jogar_macro,
    output reg jogar_micro,
    output reg [3:0] db_estado
);

    // Define estados
    parameter inicial              = 4'b0000;  // 0
    parameter preparacao           = 4'b0001;  // 1
    parameter joga_macro           = 4'b0010;  // 2
    parameter registra_macro       = 4'b0011;  // 3
    parameter joga_micro           = 4'b0100;  // 4
    parameter registra_micro       = 4'b0101;  // 5 
    parameter troca_jogador        = 4'b0110;  // 6
    parameter decide_macro         = 4'b0111;  // 7
    parameter fim                  = 4'b1111;  // F

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end
        
    // Logica de proximo estado 
    always @* begin
        case (Eatual) 
            inicial:              Eprox = (iniciar) ? preparacao : inicial;
            preparacao:           Eprox = joga_macro;
            joga_macro:           Eprox = (tem_jogada) ? registra_macro : joga_macro;
            registra_macro:       Eprox = joga_micro;
            joga_micro:           Eprox = (tem_jogada) ? registra_micro : joga_micro;
            registra_micro:       Eprox = troca_jogador;
            troca_jogador:        Eprox = (fim_jogo) ? fim : decide_macro;
            decide_macro:         Eprox = (escolhe_macro) ? preparacao : registra_macro;
            fim:                  Eprox = (iniciar) ? inicial : fim;
            
            default:              Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraR_macro     = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0; 
        zeraR_micro     = (Eatual == inicial || Eatual == preparacao || Eatual == decide_macro) ? 1'b1 : 1'b0;
        zeraEdge        = (Eatual == inicial) ? 1'b1 : 1'b0;
        registraR_macro = (Eatual == registra_macro) ? 1'b1 : 1'b0;
        registraR_micro = (Eatual == registra_micro) ? 1'b1 : 1'b0;
        pronto          = (Eatual == fim) ? 1'b1 : 1'b0;
        jogar_macro     = (Eatual == joga_macro) ? 1'b1 : 1'b0;
        jogar_micro     = (Eatual == joga_micro) ? 1'b1 : 1'b0;


        // Saida de depuracao (estado)
        case (Eatual)
            inicial:              db_estado = inicial;         
            preparacao:           db_estado = preparacao;
            joga_macro:           db_estado = joga_macro;      
            registra_macro:       db_estado = registra_macro;  
            joga_micro:           db_estado = joga_micro;      
            registra_micro:       db_estado = registra_micro; 
            troca_jogador:        db_estado = troca_jogador;
            decide_macro:         db_estado = decide_macro; 
            fim:                  db_estado = fim;             
            
            default:       db_estado = 4'b0000;           // 0
        endcase

        

    end

endmodule
