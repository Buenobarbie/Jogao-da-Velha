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



// Unidade de controle ------------------------------
unidade_controle_exp7 unidade_controle(
	.clock              (clock),
	.reset              (reset),
	.iniciar            (iniciar),
    .tem_jogada         (tem_jogada),
    .zeraR_macro        (zeraR_macro),
    .zeraR_micro        (zeraR_micro),
    .zeraEdge           (zeraEdge),
    .registraR_macro    (registraR_macro),
    .registraR_micro    (registraR_micro),
    .pronto             (pronto),
    .jogar_macro        (jogar_macro),
    .joga_micro         (joga_micro),
    .db_estado          (estado_out)
); 

// Fluxo de Dados ------------------------------
fluxo_dados_exp7 fluxo_dados (
    .clock            ( clock),
    .botoes           ( botoes),
    .zeraEdge         ( zeraEdge),
    .zeraR_macro      ( zeraR_macro), 
    .zeraR_micro      ( zeraR_micro),
    .registraR_macro  ( registraR_macro),
    .registraR_micro  ( registraR_micro),
    .tem_jogada       ( tem_jogada),
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


assign db_tem_jogada = tem_jogada;

endmodule
