`timescale 1ns/10ps

module testbench();

	parameter CLOCK_PERIOD = 40,
			  BIT_PERIOD   = 8600,
			  BIT_TO_SEND  = 7'd99,
			  ANOTHER_BIT_TO_SEND = 7'd123;
	
	reg clk = 0,
	    sin = 1,
	    wr  = 0,
	    rd  = 1,
	    success = 1;
	    
	reg [6:0] in_data = 0;
	reg [6:0] data_aux = 0;
	    
	wire [6:0] out_data;
	wire out_success, sout;
	
	integer i;
	
	// Task para simular o envio de dados por uma serial
	
	task send_data;
	input [6:0] data;
	integer     ii;
	begin
		
		// Envia start bit
		sin <= 1'b0;
		#(BIT_PERIOD);
		#1000;
		
		for(ii=0; ii<7; ii = ii + 1)
		begin
			sin <= data[ii];
			#(BIT_PERIOD);
		end
		
		// Envia bit de paridade
		sin <= (^data);
		#(BIT_PERIOD);
		
		// Envia stop bit
		sin <= 1'b1;
		#(BIT_PERIOD);
		
	end
	endtask
	
	uart uart_inst(.clk(clk), .sin(sin), .i_data(in_data), .wr(wr), .rd(rd), 
	.o_data(out_data), .sout(sout), .success(out_success));
	
	always #(CLOCK_PERIOD/2) clk <= !clk;
	
	initial
	begin
	
		// Testa enviando serial / recebendo paralelo
		@(posedge clk);
		send_data(BIT_TO_SEND);
		@(posedge clk);
		
		$display("Teste recebendo pela serial e saída paralela");
        
		if(out_success == 1'b1)
			$display("Bit de paridade indica que os dados foram enviados corretamente!");

		else
			$display("Bit de paridade indica que houve um erro :(");
		
		// Testa enviando paralelo / recebendo serial
		
		in_data <= ANOTHER_BIT_TO_SEND;
		
		rd <= 0;
		wr <= 1;
		
		@(negedge sout);
		#(BIT_PERIOD/2);
		success <= sout == 1'b0;
		#(BIT_PERIOD);
		
		$display("Teste recebendo paralelamente e saída serial");
		
		// Lógica para receber dados que estão sendo transmitidos serialmente
		for(i=0; i<7; i = i + 1)
		begin
			data_aux[i] <= sout;
			#(BIT_PERIOD);
		end
		
		success <= sout == 1'b1;
		#(BIT_PERIOD);
		success <= sout == (^data_aux);
		
		if(success == 1'b1)
			$display("Bit de paridade indica que os dados foram enviados corretamente!");

		else
			$display("Bit de paridade indica que houve um erro :(");
		
	$finish();
	end

endmodule
