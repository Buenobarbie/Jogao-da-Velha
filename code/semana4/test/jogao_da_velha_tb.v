/*
* # Cenario de Teste 3 #
* Observar a mudança de jogador
* a cada rodada macro/micro
*/

`timescale 1ns/1ns

module jogao_da_velha_tb;

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

    wire [6:0] db_jogador_out;
    wire [6:0] db_J;
    wire [6:0] db_estado_out   ;
    wire [6:0] db_macro_out    ;
    wire [6:0] db_micro_out     ;
    wire       db_tem_jogada_out ;
    wire       db_s_out;

    // Configuracao do clock
    parameter clockPeriod = 20000; // in ns, f=48kHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    jogao_da_velha dut (
      .clock          ( clock_in    ),
      .reset          ( reset_in    ),
      .iniciar        ( iniciar_in  ),
      .botoes         ( botoes_in   ),
      .leds           ( leds_out    ),
      .pronto         ( pronto_out  ),
      .db_tem_jogada  (db_tem_jogada_out ),
      .jogar_macro    (jogar_macro_out),
      .jogar_micro    (jogar_micro_out),
      .db_macro       (db_macro_out),
      .db_micro       (db_micro_out),
      .db_estado      (db_estado_out),
      .db_jogador     (db_jogador_out),
      .db_J           (db_J),
      .s_out          (db_s_out)

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
      #(110*clockPeriod);

      // Teste 3. Jogador 1 joga macro 5
      caso = 3;
      @(negedge clock_in);
      botoes_in = 9'b000010000;
      #(20*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(110*clockPeriod);

      // Teste 4. Jogador 1 joga micro 1
      caso = 4;
      @(negedge clock_in);
      botoes_in = 9'b000000001;
      #(20*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(350*clockPeriod);

      // Teste 5. Jogador 2 joga micro 5
      caso = 5;
      @(negedge clock_in);
      botoes_in = 9'b000010000;
      #(20*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 6. Jogador 1 joga micro 2
      caso = 6;
      @(negedge clock_in);
      botoes_in = 9'b000000010;
      #(20*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 7. Jogador 7 joga micro 5
      caso = 7;
      @(negedge clock_in);
      botoes_in = 9'b000010000;
      #(20*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 8. Jogador 1 joga micro 3 e ganha macro do meio
      caso = 8;
      @(negedge clock_in);
      botoes_in = 9'b000000100;
      #(20*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 9. Jogador 2 joga micro 5
      caso = 9;
      @(negedge clock_in);
      botoes_in = 9'b000010000;
      #(20*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Jogador 1 pode escolher macro
      // Teste 10. Jogador 1 joga macro 5 e o jogo não aceita
      caso = 10;
      @(negedge clock_in);
      botoes_in = 9'b000010000;
      #(20*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 11. Jogador 1 joga macro 1 e o jogo aceita
      caso = 11;
      @(negedge clock_in);
      botoes_in = 9'b000000001;
      #(20*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 12. Jogador 1 joga micro 5 e o jogo não aceita
      caso = 12;
      @(negedge clock_in);
      botoes_in = 9'b000010000;
      #(20*clockPeriod);
      botoes_in = 9'b000000000;
      // espera entre jogadas
      #(10*clockPeriod);

       // Teste 13. Jogador 1 joga macro 1 e o jogo aceita
      caso = 13;
      @(negedge clock_in);
      botoes_in = 9'b000000001;
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