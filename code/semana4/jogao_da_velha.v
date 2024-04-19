module jogao_da_velha (
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
    output [6:0] db_resultado,
    output       s_out
);

wire [3:0] uart_macro;
wire [3:0] uart_micro;
wire [3:0] uart_estado;
wire [1:0] uart_resulado_macro;
wire [1:0] uart_resulado_jogo;
wire wr;
wire sinal;


circuito_jogo circuito_jogo(
    .clock(clock),
    .reset(reset),
    .iniciar(iniciar),
    .botoes(botoes),
    .leds(leds),
    .pronto(pronto),
    .db_tem_jogada(db_tem_jogada),
    .jogar_macro(jogar_macro),
    .jogar_micro(jogar_micro),
    .uart_macro(uart_macro),
    .uart_micro(uart_micro),
    .uart_estado(uart_estado),
    .uart_resulado_macro(uart_resulado_macro),
    .uart_resulado_jogo(uart_resulado_jogo),
    .db_macro(db_macro),
    .db_micro(db_micro),
    .db_estado(db_estado),
    .db_jogador(db_jogador),
    .db_J(db_J),
    .db_resultado(db_resultado)
);

// WR = 1 
// Para uart estado = 
// 0000
// 0010
// 0101
// 1000
// 1010
// 1100
// 1111
// ABCD

assign sinal = ((~uart_estado[0] && ~uart_estado[1] && ~uart_estado[2] && ~uart_estado[3]) ||
                (~uart_estado[0] && uart_estado[1] && ~uart_estado[2] && ~uart_estado[3]) ||
                (uart_estado[0] && ~uart_estado[1] && uart_estado[2] && ~uart_estado[3]) ||
                (~uart_estado[0] && ~uart_estado[1] && ~uart_estado[2] && uart_estado[3]) ||
                (~uart_estado[0] && uart_estado[1] && ~uart_estado[2] && uart_estado[3]) ||
                (uart_estado[0] && uart_estado[1] && uart_estado[2] && uart_estado[3]));

edge_detector detect_wr
(
    .clock(clock),
    .reset(~reset),
    .sinal(sinal),
    .pulso(wr)
);


uart uart(
    .clk(clock),
    .i_data({uart_estado, uart_macro, uart_micro, uart_resulado_macro, uart_resulado_jogo}),
    .wr(wr),
    .s_out(s_out)
);


endmodule
