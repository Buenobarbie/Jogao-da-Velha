 module fluxo_dados (
input        clock,
input [8:0]  botoes,
input        zeraEdge,
input        zeraR_micro,
input        zeraR_macro,
input        troca_jogador,
input        zeraFlipFlopT,
input        registraR_micro, 
input        registraR_macro,
input        sinal_macro,
input        sinal_valida_macro,
input        we_board,
input        we_board_state,
input        contaT,
input        zeraT,

output       tem_jogada,
output       macro_vencida,
output       micro_jogada,
output       fim_jogo,
output       fimT,
output [1:0] jogador_atual,
output [8:0] leds,
output [8:0] db_macro, 
output [8:0] db_micro
);

wire sinal;

wire[8:0] macro;
wire[8:0] micro;

wire [3:0] endereco_macro;
wire [8:0] mux_macro;

wire [8:0] conversor_in;

wire [1:0] estado_micro;
wire [1:0] estado_macro;

wire [1:0] estado_jogo;

  // Memória do tabuleiro
  ram_board ram_board(
    .clk(clock),
    .we(we_board),
    .data(jogador_atual),
    .addr_macro(macro),
    .addr_micro(micro),
    .q(estado_micro),
    .state(estado_macro)
  );

  // OR entre bits do estado_macro
  // 01, 10, e 11 sao celulas vencidas
  // 00 eh celula em andamento
  assign macro_vencida = (estado_macro[0] || estado_macro[1]);

  assign micro_jogada = (estado_micro[0] || estado_micro[1]);

  // Geração do sinal dos botoes
  assign sinal = (botoes[0] ^ botoes[1] ^ botoes[2]
                ^ botoes[3] ^ botoes[4] ^ botoes[5] 
                ^ botoes[6] ^ botoes[7] ^ botoes[8]);
                
  assign db_tem_jogada = sinal; 
  

  // Deteccao da jogada
 edge_detector edge_detector(
    .clock(clock),
    .reset(zeraEdge),
    .sinal(sinal),
    .pulso(tem_jogada)
    );
  
  
  // Multiplexador
  assign mux_macro = (sinal_macro) ? botoes : micro;
  // Registrador macro
  registrador_9 registradorMacro(
		.clock(clock),
		.clear(zeraR_macro),
		.enable(registraR_macro),
		.D(mux_macro),
		.Q(macro)
  );


   // Registrador micro
  registrador_9 registradorMicro(
		.clock(clock),
		.clear(zeraR_micro),
		.enable(registraR_micro),
		.D(botoes),
		.Q(micro)
  );

  // Multiplexador
  // 0 : Validar jogada automatica (micro)
  // 1 : Validar jogada manual  (macro)
  assign conversor_in = (sinal_valida_macro) ? macro : micro;

  // Conversor de botoes para binario
  conversor conversor(
    .botoes(conversor_in),
    .binario(endereco_macro)
  );

  // Memoria do estado do tabuleiro
  ram_board_state ram_board_state(
    .clk(clock),
    .we(we_board_state),
    .addr(macro),
    .data(estado_macro),
    .q(estado_jogo)
  );

  assign fim_jogo = estado_jogo[0] || estado_jogo[1];

  // Troca de jogador
  flipflop_t flipflop_t(
    .clk(clock),
    .clear(zeraFlipFlopT),
    .t(troca_jogador),
    .q(jogador_atual)
  );

  // Timer 

    contador_m #(5, 3)temporizador(
    .clock(clock),
    .zera_as(zeraT),
    .zera_s(zeraT),
    .conta(contaT),
    .Q(),
    .fim(fimT),
    .meio()
  );



assign leds = botoes;
  
assign db_macro = macro;
assign db_micro = micro;


endmodule
