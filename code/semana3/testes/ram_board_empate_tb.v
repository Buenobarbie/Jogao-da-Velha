`timescale 1ns/1ns

      /*
       * # Cenario de Teste 1 #
       * Escrever na memória
       * e verificar vitória 
       * do jogador 1
       */

module ram_board_empate_tb;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in   = 1;
    reg        we_in      = 0;
    reg  [1:0] data_in    = 2'b00; 
    reg  [3:0] addr_macro_in = 4'b0000;
    reg  [3:0] addr_micro_in = 4'b0000;

    wire [1:0]      q_out ;
    wire [1:0]  state_out ;


    // Configuracao do clock
    parameter clockPeriod = 20; // in ns, f=50MHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    ram_board dut (
      .clk            (clock_in),
      .we             (we_in),
      .data           (data_in),
      .addr_macro     (addr_macro_in),
      .addr_micro     (addr_micro_in),
      .q              (q_out),
      .state          (state_out)
    );

    // geracao dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

      // condicoes iniciais
      caso       = 0;
      clock_in   = 1;
      we_in      = 0;
      data_in    = 2'b00;
      addr_macro_in = 4'b0000;
      addr_micro_in = 4'b0000;

      #clockPeriod;


      // Teste 1. Jogadro 1 jogar em 2 1
      // Escreve 01 em [0010][0001]
      caso = 1;
      @(negedge clock_in);
      addr_macro_in = 4'b0010;
      addr_micro_in = 4'b0001;
      data_in = 2'b01;
      we_in = 1;
      #(5*clockPeriod);
      addr_macro_in = 4'b0000;
      addr_micro_in = 4'b0000;
      data_in = 2'b00;
      we_in = 0;
      #(5*clockPeriod);

      // Teste 2. Jogadro 1 jogar em 2 2
      // Escreve 01 em [0010][0010]
      caso = 2;
      @(negedge clock_in);
      addr_macro_in = 4'b0010;
      addr_micro_in = 4'b0010;
      data_in = 2'b01;
      we_in = 1;
      #(5*clockPeriod);
      addr_macro_in = 4'b0000;
      addr_micro_in = 4'b0000;
      data_in = 2'b00;
      we_in = 0;
      #(5*clockPeriod);

      // Teste 3. Jogadro 1 jogar em 2 3
      // Escreve 01 em [0010][0011]
      caso = 3;
      @(negedge clock_in);
      addr_macro_in = 4'b0010;
      addr_micro_in = 4'b0011;
      data_in = 2'b10;
      we_in = 1;
      #(5*clockPeriod);
      addr_macro_in = 4'b0000;
      addr_micro_in = 4'b0000;
      data_in = 2'b00;
      we_in = 0;
      #(5*clockPeriod);

      // Teste 4. Jogadro 2 jogar em 2 4
      // Escreve 01 em [0010][0011]
      caso = 4;
      @(negedge clock_in);
      addr_macro_in = 4'b0010;
      addr_micro_in = 4'b0100;
      data_in = 2'b10;
      we_in = 1;
      #(5*clockPeriod);
      addr_macro_in = 4'b0000;
      addr_micro_in = 4'b0000;
      data_in = 2'b00;
      we_in = 0;
      #(5*clockPeriod);

      // Teste 5. Jogadro 2 jogar em 2 3
      // Escreve 01 em [0010][0011]
      caso = 5;
      @(negedge clock_in);
      addr_macro_in = 4'b0010;
      addr_micro_in = 4'b0101;
      data_in = 2'b10;
      we_in = 1;
      #(5*clockPeriod);
      addr_macro_in = 4'b0000;
      addr_micro_in = 4'b0000;
      data_in = 2'b00;
      we_in = 0;
      #(5*clockPeriod);

      // Teste 6. Jogadro 1 jogar em 2 3
      // Escreve 01 em [0010][0011]
      caso = 6;
      @(negedge clock_in);
      addr_macro_in = 4'b0010;
      addr_micro_in = 4'b0110;
      data_in = 2'b01;
      we_in = 1;
      #(5*clockPeriod);
      addr_macro_in = 4'b0000;
      addr_micro_in = 4'b0000;
      data_in = 2'b00;
      we_in = 0;
      #(5*clockPeriod);

      // Teste 7. Jogadro 1 jogar em 2 3
      // Escreve 01 em [0010][0011]
      caso = 7;
      @(negedge clock_in);
      addr_macro_in = 4'b0010;
      addr_micro_in = 4'b0111;
      data_in = 2'b01;
      we_in = 1;
      #(5*clockPeriod);
      addr_macro_in = 4'b0000;
      addr_micro_in = 4'b0000;
      data_in = 2'b00;
      we_in = 0;
      #(5*clockPeriod);

      // Teste 8. Jogadro 1 jogar em 2 3
      // Escreve 01 em [0010][0011]
      caso = 8;
      @(negedge clock_in);
      addr_macro_in = 4'b0010;
      addr_micro_in = 4'b1000;
      data_in = 2'b01;
      we_in = 1;
      #(5*clockPeriod);
      addr_macro_in = 4'b0000;
      addr_micro_in = 4'b0000;
      data_in = 2'b00;
      we_in = 0;
      #(5*clockPeriod);

      // Teste 9. Jogadro 1 jogar em 2 3
      // Escreve 01 em [0010][0011]
      caso = 9;
      @(negedge clock_in);
      addr_macro_in = 4'b0010;
      addr_micro_in = 4'b1001;
      data_in = 2'b10;
      we_in = 1;
      #(5*clockPeriod);
      addr_macro_in = 4'b0000;
      addr_micro_in = 4'b0000;
      data_in = 2'b00;
      we_in = 0;
      #(5*clockPeriod);


      // final dos casos de teste da simulacao
      caso = 99;
      #100;
      $display("Fim da simulacao");
      $stop;
    end

  endmodule
