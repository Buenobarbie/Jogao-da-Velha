module uart

// frequencia de clock = 48kHz
// baud rate = 9600
// CLK_PER_BIT = 48000 / 9600 = 5
// tempo de bit = 1/9600 = 104.16666666666667us

#(parameter CLKS_PER_BIT = 5)
(input clk,
 input [15:0] i_data, 
 input wr,
 output reg s_out);
	
	parameter START_BIT = 1'b0,
			  STOP_BIT  = 1'b1;
			  
	// Estados da máquina de estados para transmitir serialmente
	parameter T_WAIT      = 3'b100,
			  T_START_BIT = 3'b101,
			  T_DATA_BITS = 3'b110,
			  T_STOP_BIT  = 3'b111;
	
	// Auxílio para controlar a máquina de estados
	reg [7:0]  clk_counter = 0;
	reg [3:0]  index       = 0;
	reg [15:0] data_aux    = 0;
	reg [2:0]  t_state     = T_WAIT;

	reg sending = 0;
	
	always @(posedge clk)
	begin
		if (wr == 1'b1) 
		begin
			sending <= 1'b1;
		end

		if (sending == 1'b1)
		begin
			// Máquina de estados para enviar dados seriais
			case(t_state)
				
				// Estado que garante que o stop bit permaneça por pelo menos um perído, se necessário para finalizar envio de dados anterior
				// Obs.: Quando o sinal wr está em nível lógico alto já pressupomos que os dados foram enviados para a entrada paralela e que queremos transmití-los serialmente de imediato; os dados da entrada são salvos em um registrador para que não sejam perdidos caso sofram instabilidade durante a transmissão
				T_WAIT:
				begin
					s_out <= STOP_BIT;
					if(clk_counter < CLKS_PER_BIT - 1)
					begin
						clk_counter <= clk_counter + 1;
						t_state <= T_WAIT;
					end
					else
					begin
						clk_counter <= 0;
						clk_counter <= 0;
						index       <= 0;
						t_state     <= T_START_BIT;
						data_aux <= i_data;
					end
					
				end
				
				// Envia start bit
				T_START_BIT:
				begin
					s_out <= START_BIT;
					if(clk_counter < CLKS_PER_BIT - 1)
					begin
						clk_counter <= clk_counter + 1;
						t_state <= T_START_BIT;
					end
					else
					begin
						clk_counter <= 0;
						t_state <= T_DATA_BITS;
					end
		
				end

				T_DATA_BITS:	
				// Envia bits de dados sequencialmente, fazendo o controle necessário para que cada um permaneça pelo tempo adequado; 
				begin
					if(clk_counter < CLKS_PER_BIT - 1)
					begin
						clk_counter <= clk_counter + 1;
						t_state <= T_DATA_BITS;
					end
					else
					begin
						clk_counter <= 0;
						if(index < 15)
						begin
							s_out <= data_aux[index];
							index <= index + 1;
							t_state <= T_DATA_BITS; 
						end
						
						else
						begin
							s_out <= data_aux[15];
							index <= 0;
							t_state <= T_STOP_BIT;
						end
					end
				end
				
				// Envia stop bit
				T_STOP_BIT:
				begin
					if(clk_counter < CLKS_PER_BIT - 1)
					begin
						clk_counter <= clk_counter + 1;
						t_state <= T_STOP_BIT;
					end
					else
					begin
						clk_counter <= 0;
						s_out <= STOP_BIT;
						t_state <= T_WAIT;
						sending <= 1'b0;
					end
				end
				
			endcase
			
		end
		// Se wr não está habilitado, os estados voltam para o estado inicial
		else
		begin
			t_state <= T_WAIT;
			s_out <= 1'b1;
		end
	end
		
endmodule

