/*
* # Cenario de Teste 1 #
* Jogar em uma célula micro
* que corresponde a uma macro vencida
*/

`timescale 1ns/1ns

module celula_vencida_tb;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        iniciar_in = 0;
    reg  [8:0] botoes_in  = 9'b000000000;

    wire       pronto_out ;
    wire [8:0] leds_out   ;
    wire       jogar_macro_out;
    wire       jogar_micro_out;

    wire [6:0] db_estado_out   ;
    wire [6:0] db_macro_out    ;
    wire [6:0] db_micro_out     ;
    wire       db_tem_jogada_out ;

    // Configuracao do clock
    parameter clockPeriod = 20; // in ns, f=50MHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    circuito_jogo dut (
      .clock          ( clock_in    ),
      .reset          ( reset_in    ),
      .iniciar        ( iniciar_in  ),
      .botoes         ( botoes_in   ),
      .pronto         ( pronto_out  ),
      .leds           ( leds_out    ),
      .db_tem_jogada  (db_tem_jogada_out ),
      .jogar_macro    (jogar_macro_out),
      .jogar_micro    (jogar_micro_out),
      .db_macro       (db_macro_out),
      .db_micro       (db_micro_out),
      .db_estado      (db_estado_out)

    );

    // geracao dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

      // condicoes iniciais
      caso       = 0;
      clock_in   = 1;
      reset_in   = 0;
      iniciar_in = 0;
      botoes_in  = 9'b000000000;
      #clockPeriod;



      // Teste 1. resetar circuito
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      reset_in = 1;
      #(clockPeriod);
      reset_in = 0;
      // espera
      #(10*clockPeriod);

      // Teste 2. iniciar=1 por 5 periodos de clock
      caso = 2;
      iniciar_in = 1;
      #(5*clockPeriod);
      iniciar_in = 0;
      // espera
      #(10*clockPeriod);

      // Teste 3. jogada macro (pressionar botao 4 por 20 periodos de clock)
      caso = 3;
      @(negedge clock_in);
      botoes_in = 9'b000001000;
      #(20*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 4. jogada micro (pressionar botao 5 por 20 periodos de clock)
      caso = 4;
      @(negedge clock_in);
      botoes_in = 9'b000010000;
      #(20*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 5. Escolher próximo macro pois a célula estava vencida
      // (pressionar botao 2 por 20 periodos de clock)
      caso = 5;
      @(negedge clock_in);
      botoes_in = 9'b000000010;
      #(20*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 6. jogada micro (pressionar botao 3 por 20 periodos de clock)
      caso = 6;
      @(negedge clock_in);
      botoes_in = 9'b000000100;
      #(20*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(10*clockPeriod);

      // final dos casos de teste da simulacao
      caso = 99;
      #100;
      $display("Fim da simulacao");
      $stop;
    end

  endmodule
