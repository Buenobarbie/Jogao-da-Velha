module fluxo_dados (
input        clock,
input [8:0]  botoes,
input        zeraEdge,
input        zeraR_micro,
input        zeraR_macro,
input        registraR_micro, 
input        registraR_macro,
input        sinal_macro,
  
output       tem_jogada,
output       escolhe_macro,
output       fim_jogo,
output [8:0] leds,
output [8:0] db_macro, 
output [8:0] db_micro
);


wire sinal;

wire[8:0] macro;
wire[8:0] micro;

wire estado_macro;
wire endereco_macro;
wire mux_macro;

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

  // Conversor de botoes para binario
  conversor conversor(
    .botoes(micro),
    .binario(endereco_macro)
  )

  // Memoria do estado do tabuleiro
  ram_board_state ram_board_state(
    .clock(clock),
    .we(1'b0),
    .addr(endereco_macro),
    .data(2'b00),
    .q(estado_macro)
  );

  // AND entre bits do estado_macro
  // 01, 10, e 11 sao celulas vencidas
  // 00 eh celula em andamento
  assign escolhe_macro = (estado_macro[0] & estado_macro[1]);

  // // Troca de jogador
  // flipflop_t flipflop_t(
  //   .clk(clock),
  //   .clear(zeraFlipFlopT),
  //   .t(troca_jogador),
  //   .q(jogador_atual)
  // );


  // TODO: FIM DO JOGO
  assign fim_jogo = 1'b0;

assign leds = botoes;
  
assign db_macro = macro;
assign db_micro = micro;


endmodule
