module fluxo_dados (
input        clock,
input [8:0]  botoes,
input        zeraEdge,
input        zeraR_micro,
input        zeraR_macro,
input        registraR_micro, 
input        registraR_micro,
  
output       tem_jogada,
output [8:0] leds,
output [8:0] db_macro, 
output [8:0] db_micro,
);


wire sinal;

wire[8:0] macro;
wire[9:0] micro;
  
  
  // Registrador macro
  registrador_9 registradorMacro(
  .clock(clock),
  .clear(zeraR_macro),
  .enable(registraR_macro),
  .D(botoes),
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


  // Geração do sinal dos botoes
  assign sinal = (botoes[0] ^ botoes[1] ^ botoes[2]
                ^ botoes[3] ^ botoes[4] ^ botoes[5] 
                ^ botoes[6] ^ botoes[7] ^ botoes[8]);
                
  assign db_tem_jogada = sinal; 
  

  // edge detector
    edge_detector edge_detector(
    .clock(clock),
    .reset(zeraEdge),
    .sinal(sinal),
    .pulso(jogada_feita)
    );

assign leds = botoes;
  
assign db_macro = macro;
assign db_micro = micro;


endmodule
