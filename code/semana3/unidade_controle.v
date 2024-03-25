
module unidade_controle (
    input      clock,
    input      reset,
    input      iniciar,
    input      tem_jogada,
    input      fim_jogo,
    input      macro_vencida,
    input      micro_jogada,
    input      fimT,
    output reg sinal_macro,
    output reg sinal_valida_macro,
    output reg troca_jogador,
    output reg zeraFlipFlopT,
    output reg zeraR_macro,
    output reg zeraR_micro,
    output reg zeraEdge,
    output reg zeraT,
    output reg contaT,
    output reg registraR_macro,
    output reg registraR_micro,
    output reg we_board,
    output reg we_board_state,
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
    parameter valida_macro         = 4'b0100;  // 4
    parameter joga_micro           = 4'b0101;  // 5
    parameter registra_micro       = 4'b0110;  // 6
    parameter valida_micro         = 4'b0111;  // 7 
    parameter registra_jogada      = 4'b1000;  // 8
    parameter verifica_macro       = 4'b1001;  // 9
    parameter registra_resultado   = 4'b1010;  // A
    parameter verifica_tabuleiro   = 4'b1011;  // B
    parameter trocar_jogador       = 4'b1100;  // C
    parameter decide_macro         = 4'b1101;  // D
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
            registra_macro:       Eprox = valida_macro	
            valida_macro:         Eprox = (!fimT) ? valida_macro : (macro_vencida) ? preparacao : joga_micro;
            joga_micro:           Eprox = (tem_jogada) ? registra_micro : joga_micro;
            registra_micro:       Eprox = valida_micro;
            valida_micro:         Eprox = (!fimT) ? valida_micro : (micro_jogada) ? joga_micro : registra_jogada;
            registra_jogada:      Eprox = verifica_macro;
            verifica_macro        Eprox = registra_resultado;
            registra_resultado:   Eprox = verifica_tabuleiro;
            verifica_tabuleiro:   Eprox = (fim_jogo) ? fim : trocar_jogador;
            trocar_jogador:       Eprox = decide_macro;
            decide_macro:         Eprox = (macro_vencida) ? preparacao : joga_micro;
            fim:                  Eprox = (iniciar) ? inicial : fim;
            
            default:              Eprox = inicial;
        endcase
    end
 
    // Logica de saida (maquina Moore)
    always @* begin
        zeraR_macro        = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0; 
        zeraR_micro        = (Eatual == inicial || Eatual == preparacao || Eatual == joga_micro) ? 1'b1 : 1'b0;
        zeraEdge           = (Eatual == inicial) ? 1'b1 : 1'b0;
        registraR_macro    = (Eatual == registra_macro || Eatual == decide_macro) ? 1'b1 : 1'b0;
        registraR_micro    = (Eatual == registra_micro) ? 1'b1 : 1'b0;
        pronto             = (Eatual == fim) ? 1'b1 : 1'b0;
        jogar_macro        = (Eatual == joga_macro) ? 1'b1 : 1'b0;
        jogar_micro        = (Eatual == joga_micro) ? 1'b1 : 1'b0;
        sinal_macro        = (Eatual == joga_macro || Eatual == registra_macro) ? 1'b1 : 1'b0;
        troca_jogador      = (Eatual == trocar_jogador) ? 1'b1 : 1'b0;
        zeraFlipFlopT      = (Eatual == inicial) ? 1'b1 : 1'b0;
        sinal_valida_macro = (Eatual == registra_macro || Eatual == valida_macro || Eatual == temp) ? 1'b1 : 1'b0;
        zeraT              = (Eatual == inicial || Eatual == registra_macro || Eatual == registra_micro ) ? 1'b1 : 1'b0;
        contaT             = (Eatual == valida_macro || Eatual == valida_micro) ? 1'b1 : 1'b0;
        we_board           = (Eatual == registra_jogada) ? 1'b1 : 1'b0;
        we_board_state     = (Eatual == registra_resultado) ? 1'b1 : 1'b0;
        
        
        // Saida de depuracao (estado)
        case (Eatual)
            inicial:               db_estado = inicial;            // 0   
            preparacao:            db_estado = preparacao;         // 1
            joga_macro:            db_estado = joga_macro;         // 2
            registra_macro:        db_estado = registra_macro;     // 3 
            valida_macro           db_estado = valida_macro;       // 4
            joga_micro:            db_estado = joga_micro;         // 5 
            registra_micro:        db_estado = registra_micro;     // 6
            valida_micro:          db_estado = valida_micro;       // 7
            registra_jogada:       db_estado = registra_jogada;    // 8
            verifica_macro:        db_estado = verifica_macro;     // 9
            registra_resultado:    db_estado = registra_resultado; // A
            verifica_tabuleiro:    db_estado = verifica_macro;     // B
            trocar_jogador:        db_estado = trocar_jogador;     // C 
            decide_macro:          db_estado = decide_macro;       // D
            fim:                   db_estado = fim;                // F        
            
            default:               db_estado = 4'b1110;            // E (ERRO)
        endcase
        
    end

endmodule
