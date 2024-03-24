
module unidade_controle (
    input      clock,
    input      reset,
    input      iniciar,
    input      tem_jogada,
    input      fim_jogo,
    input      macro_vencida,
    output reg sinal_macro,
    output reg sinal_valida_macro,
    output reg troca_jogador,
    output reg zeraFlipFlopT,
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
    parameter valida_macro         = 4'b1000;  // 8
	 parameter temp                 = 4'b1001;
    parameter joga_micro           = 4'b0100;  // 4
    parameter registra_micro       = 4'b0101;  // 5 
    parameter trocar_jogador       = 4'b0110;  // 6
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
            registra_macro:       Eprox = temp;
				temp:                 Eprox = valida_macro;
            valida_macro:         Eprox = (macro_vencida) ? preparacao : joga_micro;
            joga_micro:           Eprox = (tem_jogada) ? registra_micro : joga_micro;
            registra_micro:       Eprox = trocar_jogador;
            trocar_jogador:       Eprox = (fim_jogo) ? fim : decide_macro;
            decide_macro:         Eprox = (macro_vencida) ? preparacao : joga_micro;
            fim:                  Eprox = (iniciar) ? inicial : fim;
            
            default:              Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraR_macro     = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0; 
        zeraR_micro     = (Eatual == inicial || Eatual == preparacao || Eatual == joga_micro) ? 1'b1 : 1'b0;
        zeraEdge        = (Eatual == inicial) ? 1'b1 : 1'b0;
        registraR_macro = (Eatual == registra_macro || Eatual == decide_macro) ? 1'b1 : 1'b0;
        registraR_micro = (Eatual == registra_micro) ? 1'b1 : 1'b0;
        pronto          = (Eatual == fim) ? 1'b1 : 1'b0;
        jogar_macro     = (Eatual == joga_macro) ? 1'b1 : 1'b0;
        jogar_micro     = (Eatual == joga_micro) ? 1'b1 : 1'b0;
        sinal_macro     = (Eatual == joga_macro || Eatual == registra_macro) ? 1'b1 : 1'b0;
        troca_jogador   = (Eatual == trocar_jogador) ? 1'b1 : 1'b0;
        zeraFlipFlopT   = (Eatual == inicial) ? 1'b1 : 1'b0;
        sinal_valida_macro = (Eatual == registra_macro || Eatual == valida_macro || Eatual == temp) ? 1'b1 : 1'b0;


        // Saida de depuracao (estado)
        case (Eatual)
            inicial:               db_estado = inicial;         
            preparacao:            db_estado = preparacao;
            joga_macro:            db_estado = joga_macro;      
            registra_macro:        db_estado = registra_macro;  
            joga_micro:            db_estado = joga_micro;      
            registra_micro:        db_estado = registra_micro; 
            trocar_jogador:        db_estado = trocar_jogador;
            decide_macro:          db_estado = decide_macro; 
            valida_macro:          db_estado = valida_macro;
				temp:                  db_estado = temp;
            fim:                   db_estado = fim;             
            
            default:               db_estado = 4'b0000;           // 0
        endcase

        

    end

endmodule
