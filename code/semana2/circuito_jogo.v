module circuito_jogo (
 input        clock,
 input        reset,
 input        iniciar,
 input  [8:0] botoes,
 output [8:0] leds,
 output       pronto,
 output       db_tem_jogada,
 output       jogar_macro,
 output       jogar_micro,
 output [6:0] db_macro,
 output [6:0] db_micro,
 output [6:0] db_estado, 
 output [6:0] db_jogador,
 output [6:0] db_J
);


wire zeraR_micro;
wire registraR_micro;

wire zeraR_macro;
wire registraR_macro;

wire zeraEdge;

wire tem_jogada;


wire [3:0] estado_out;
wire [8:0] macro_out;
wire [8:0] micro_out;

wire fim_jogo;
wire escolhe_macro;
wire sinal_macro;
wire troca_jogador;
wire zeraFlipFlopT;
wire jogador_atual;

// Unidade de controle ------------------------------
unidade_controle unidade_controle(
	.clock              (clock),
	.reset              (reset),
	.iniciar            (iniciar),
    .tem_jogada         (tem_jogada),
    .fim_jogo           (fim_jogo),
    .escolhe_macro      (escolhe_macro),
    .sinal_macro        (sinal_macro),
    .troca_jogador      (troca_jogador),
    .zeraFlipFlopT      (zeraFlipFlopT),
    .zeraR_macro        (zeraR_macro),
    .zeraR_micro        (zeraR_micro),
    .zeraEdge           (zeraEdge),
    .registraR_macro    (registraR_macro),
    .registraR_micro    (registraR_micro),
    .pronto             (pronto),
    .jogar_macro        (jogar_macro),
    .jogar_micro        (jogar_micro),
    .db_estado          (estado_out)
); 

// Fluxo de Dados ------------------------------
fluxo_dados fluxo_dados (
    .clock            ( clock),
    .botoes           ( botoes),
    .zeraEdge         ( zeraEdge),
    .zeraR_micro      ( zeraR_micro),
    .zeraR_macro      ( zeraR_macro), 
    .troca_jogador    ( troca_jogador),
    .zeraFlipFlopT    ( zeraFlipFlopT),
    .registraR_macro  ( registraR_macro),
    .registraR_micro  ( registraR_micro),
    .sinal_macro      ( sinal_macro),
    .tem_jogada       ( tem_jogada),
    .escolhe_macro    ( escolhe_macro),
    .fim_jogo         ( fim_jogo),
    .jogador_atual    ( jogador_atual),
    .leds             ( leds),
    .db_macro         ( macro_out),
    .db_micro         ( micro_out)
);

// Display0 -----------------------------------
hexa7seg_custom HEX0(
	.hexa(macro_out),
	.display(db_macro)
);

// Display1 -----------------------------------
hexa7seg_custom HEX1(
	.hexa(micro_out),
	.display(db_micro)
);

// Display2 -----------------------------------
hexa7seg HEX2(
	.hexa(estado_out),
	.display(db_estado)
);

// Display3 -----------------------------------
hexa7seg_jogador HEX3(
    .jogador(jogador_atual),
    .display(db_jogador)
); 

// Display4 -----------------------------------
hexa7seg_J HEX4(
    .habilita_J(1'b1),
    .J(db_J)
);

assign db_tem_jogada = tem_jogada;

endmodule
