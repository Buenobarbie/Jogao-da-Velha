
module unidade_controle (
    input      clock,
    input      reset,
    input      iniciar,
    input      tem_jogada,
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
    parameter joga_macro           = 4'b0001;  // 1
    parameter registra_macro       = 4'b0010;  // 2
    parameter joga_micro           = 4'b0011;  // 3
    parameter registra_micro       = 4'b0100;  // 4 
    parameter fim                  = 4'b0101;  // 5 

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
            inicial:              Eprox = (iniciar) ? joga_macro : inicial;
            joga_macro:           Eprox = (tem_jogada) ? registra_macro : joga_macro;
            registra_macro:       Eprox = joga_micro;
            joga_micro:           Eprox = (tem_jogada) ? registra_micro : joga_micro;
            registra_micro:       Eprox = fim;
            fim:                  Eprox = (iniciar) ? joga_macro;
            
            default:              Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraR_macro     = (Eatual == inicial) ? 1'b1 : 1'b0; 
        zeraR_micro     = (Eatual == inicial) ? 1'b1 : 1'b0;
        zeraEdge        = (Eatual == inicial) ? 1'b1 : 1'b0;
        registraR_macro = (Eatual == registra_macro) ? 1'b1 : 1'b0;
        registraR_micro = (Eatual == registra_micro) ? 1'b1 : 1'b0;
        pronto          = (Eatual == fim) ? 1'b1 : 1'b0;
        jogar_macro     = (Eatual == joga_macro) ? 1'b1 : 1'b0;
        jogar_micro     = (Eatual == joga_micro) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:              db_estado = inicial;         // 0
            joga_macro:           db_estado = joga_macro;      // 1
            registra_macro:       db_estado = registra_macro;  // 2
            joga_micro:           db_estado = joga_micro;      // 3
            registra_micro:       db_estado = registra_micro;  // 4
            fim:                  db_estado = fim;             // 5
            
            default:       db_estado = 4'b0000;           // 0
        endcase

        

    end

endmodule
