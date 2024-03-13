`timescale 1ns/1ns

module semana1_tb;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        iniciar_in = 0;
    reg  [8:0] botoes_in  = 9'b000000000;

    wire       pronto_out ;
    wire [8:0] leds_out   ;
    wire       joga_macro;
    wire       joga_micro;

    wire [6:0] db_estado_out   ;
    wire [6:0] db_macro_out    ;
    wire [6:0] db_micro_out     ;
    wire       db_tem_jogada_out ;

    // Configuração do clock
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
      .db_tem_jogada  (db_tem_jogada_out),
      .jogar_macro    (jogar_macro),
      .jogar_micro    (jogar_micro),
      .db_macro       (db_macro),
      .db_micro       (db_micro),
      .db_estado      (db_estado)

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

      /*
       * # Cenario de Teste 1 #
       * Executar duas jogadas
       * e reiniciar a operação
       */

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

      // Teste 3. jogada macro (pressionar botão 4 por 2 periodos de clock)
      caso = 3;
      @(negedge clock_in);
      botoes_in = 9'b000001000;
      #(2*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 4. jogada micro (pressionar botão 5 por 2 periodos de clock)
      caso = 4;
      @(negedge clock_in);
      botoes_in = 9'b000010000;
      #(2*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 5. Aguardar no estado fim por 20 períodos de clock
      caso = 5;
      @(negedge clock_in);
      botoes_in = 9'b000000000;
      #(20*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 6. Reiniciar no estado fim
      caso = 6;
      iniciar_in = 1;
      #(5*clockPeriod);
      iniciar_in = 0;
      // espera
      #(10*clockPeriod);

       // Teste 7. jogada macro (pressionar botão 2 por 2 periodos de clock)
      caso = 7;
      @(negedge clock_in);
      botoes_in = 9'b000000010;
      #(2*clockPeriod);
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