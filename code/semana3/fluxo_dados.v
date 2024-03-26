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

// Edge Detector
wire sinal;

// Registrador Macro
wire [8:0] mux_macro;
wire[8:0] macro;

// Registrador Micro
wire[8:0] micro;

wire [3:0] endereco_macro;

wire [8:0] conversor_in;

wire [1:0] estado_micro;
wire [1:0] estado_macro;

wire [1:0] estado_jogo;

wire [3:0] addr_macro;
wire [3:0] addr_micro;

wire [1:0]saida_ram_state;


  // ------------ DETECTAR A JOGADA ---------------------

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

  // ----------- REGISTRAR A JOGADA MACRO ----------------
  // Multiplexador
  // Registra jogada manual(botoes) ou automatica (micro)
  assign mux_macro = (sinal_macro) ? botoes : micro;

  // Registrador macro
  registrador_9 registradorMacro(
		.clock(clock),
		.clear(zeraR_macro),
		.enable(registraR_macro),
		.D(mux_macro),
		.Q(macro)
  );

  // ----------- REGISTRAR A JOGADA MICRO ----------------
  // Registrador micro
  registrador_9 registradorMicro(
		.clock(clock),
		.clear(zeraR_micro),
		.enable(registraR_micro),
		.D(botoes),
		.Q(micro)
  );

  // ----------- REGISTRAR A JOGADA NO TABULEIRO --------------------

  // ## Converter jogada para enderecos
  // Converter macro em addr_macro
    conversor conversor_addr_macro(
    .botoes(macro),
    .binario(addr_macro)
  );

  // Converter micro em addr_micro
    conversor conversor_addr_micro(
    .botoes(micro),
    .binario(addr_micro)
  );

  // Memória do tabuleiro
  ram_board ram_board(
    .clk(clock),
    .we(we_board),
    .data(jogador_atual),
    .addr_macro(addr_macro),
    .addr_micro(addr_micro),
    .q(estado_micro),
    .state(estado_macro)
  );

  // -------------- VALIDAR JOGADA MICRO --------------------

  // Verifica se a micro esta disponivel
  // 1: micro já possui jogada
  // 0: micro está disponível
  assign micro_jogada = (estado_micro[0] || estado_micro[1]);


  // -------------- VALIDA JOGADA MACRO --------------------

  // Multiplexador
  // 0 : Validar jogada automatica (micro)
  // 1 : Validar jogada manual  (macro)
  assign conversor_in = (sinal_valida_macro) ? macro : micro;

  // Convere a jogada em endereco
  conversor conversor(
    .botoes(conversor_in),
    .binario(endereco_macro)
  );

  // OR entre bits do estado_macro
  // 01, 10, e 11 sao celulas vencidas
  // 00 eh celula em andamento
  assign macro_vencida = (saida_ram_state[0] || saida_ram_state[1]);

  // --------------- MEMORIA DOS JOGOS DO TABULEIRO --------------------

  // Memoria do estado do tabuleiro
  ram_board_state ram_board_state(
    .clk(clock),
    .we(we_board_state),
    .addr(endereco_macro),
    .data(estado_macro),
    .state_final(estado_jogo),
    .Q(saida_ram_state)
  );

  // Verifica se o jogo acabou
  assign fim_jogo = estado_jogo[0] || estado_jogo[1];
  
  // --------------- TROCAR JOGADOR --------------------
  // Troca de jogador
  flipflop_t flipflop_t(
    .clk(clock),
    .clear(zeraFlipFlopT),
    .t(troca_jogador),
    .q(jogador_atual)
  );

  // --------------- TEMPORIZADOR -------------------- 
  // Tempo de espera para atualizacao do sinal
    contador_m #(5, 3)temporizador(
    .clock(clock),
    .zera_as(zeraT),
    .zera_s(zeraT),
    .conta(contaT),
    .Q(),
    .fim(fimT),
    .meio()
  );

// Acender o led do botao pressionado
assign leds = botoes;

// Exibir jogadas dos registradores nos displays
assign db_macro = macro;
assign db_micro = micro;


endmodule
