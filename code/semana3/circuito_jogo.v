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
 output [6:0] db_J,
 output [6:0] db_resultado
);


wire zeraR_micro;
wire registraR_micro;

wire zeraR_macro;
wire registraR_macro;

wire zeraEdge;

wire tem_jogada;

wire zeraRAM;


wire [3:0] estado_out;
wire [8:0] macro_out;
wire [8:0] micro_out;

wire fim_jogo;
wire macro_vencida;
wire sinal_macro;
wire troca_jogador;
wire zeraFlipFlopT;
wire [1:0] jogador_atual;
wire micro_jogada;

wire sinal_valida_macro;
wire fimT;

wire zeraT;
wire contaT;
wire we_board;
wire we_board_state;

wire resultado_out;

// Unidade de controle ------------------------------
unidade_controle unidade_controle(
	.clock              (clock),
	.reset              (reset),
	.iniciar            (iniciar),
    .tem_jogada         (tem_jogada),
    .fim_jogo           (fim_jogo),
    .macro_vencida      (macro_vencida),
    .micro_jogada       (micro_jogada),
    .fimT               (fimT),
    .sinal_macro        (sinal_macro),
    .sinal_valida_macro (sinal_valida_macro),
    .troca_jogador      (troca_jogador),
    .zeraFlipFlopT      (zeraFlipFlopT),
    .zeraR_macro        (zeraR_macro),
    .zeraR_micro        (zeraR_micro),
    .zeraEdge           (zeraEdge),
    .zeraT              (zeraT),
    .zeraRAM            (zeraRAM),
    .contaT             (contaT),
    .registraR_macro    (registraR_macro),
    .registraR_micro    (registraR_micro),
    .we_board           (we_board),
    .we_board_state     (we_board_state),
    .pronto             (pronto),
    .jogar_macro        (jogar_macro),
    .jogar_micro        (jogar_micro),
    .db_estado          (estado_out)
); 

// Fluxo de Dados ------------------------------
fluxo_dados fluxo_dados (
    .clock              ( clock ),
    .botoes             ( botoes ),
    .zeraEdge           ( zeraEdge ),
    .zeraR_micro        ( zeraR_micro),
    .zeraR_macro        ( zeraR_macro ), 
    .troca_jogador      ( troca_jogador ),
    .zeraFlipFlopT      ( zeraFlipFlopT ),
	 .zeraT              ( zeraT ),
     .zeraRAM            (zeraRAM),
    .registraR_macro    ( registraR_macro ),
    .registraR_micro    ( registraR_micro ),
    .sinal_macro        ( sinal_macro ),
    .we_board           ( we_board ),
    .we_board_state     ( we_board_state ),
    .contaT             ( contaT ),
    .tem_jogada         ( tem_jogada ),
    .macro_vencida      ( macro_vencida ),
	 .micro_jogada       ( micro_jogada ),
	 .fimT               ( fimT ),
    .fim_jogo           ( fim_jogo),
    .jogador_atual      ( jogador_atual),
    .leds               ( leds),
    .db_macro           ( macro_out ),
    .db_micro           ( micro_out ),
    .sinal_valida_macro ( sinal_valida_macro ),
    .db_resultado       ( resultado_out ),
);

// Display0 -----------------------------------
hexa7seg_custom HEX0(
	.hexa(micro_out),
	.display(db_micro)
);

// Display1 -----------------------------------
hexa7seg_custom HEX1(
	.hexa(macro_out),
	.display(db_macro)
);



// Display2 -----------------------------------
hexa7seg_jogador HEX2(
    .jogador(jogador_atual),
    .display(db_jogador)
); 

// Display3 -----------------------------------
hexa7seg_J HEX3(
    .habilita_J(1'b1),
    .J(db_J)
);

// Display4 -----------------------------------
hexa7seg_jogador HEX4(
    .jogador(resultado_out),
    .display(db_resultado)
);

// Display5 -----------------------------------
hexa7seg HEX5(
	.hexa(estado_out),
	.display(db_estado)
);

assign db_tem_jogada = tem_jogada;

endmodule
