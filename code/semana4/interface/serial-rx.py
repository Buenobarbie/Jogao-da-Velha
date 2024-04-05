import serial

TEST = 0

PORT = 'COM19'  # Change this to your serial port
BAUDRATE = 9600

if not TEST:
    # Define the serial port and parameters
    ser = serial.Serial(
        port     = PORT,           
        baudrate = BAUDRATE,
        bytesize = serial.EIGHTBITS,      # 8 data bits
        parity   = serial.PARITY_NONE,    # No parity bit
        stopbits = serial.STOPBITS_ONE    # 1 stop bit
    )

global JOGA_MACRO
global JOGA_MICRO
global REGISTRA_JOGADA
global REGISTRA_RESULTADO
global TROCA_JOGADOR
global FIM

JOGA_MACRO = "0010"
JOGA_MICRO = "0101"
REGISTRA_JOGADA = "1000"
REGISTRA_RESULTADO = "1010"
TROCA_JOGADOR = "1100"
FIM = "1111"


def split_data(data1, data2):
    estado = data2[0:4]
    macro = data2[4:8]
    micro = data1[0:4]
    estado_macro = data1[4:6]
    estado_jogo = data1[6:8]

    return [estado, macro, micro, estado_macro, estado_jogo]

def update_board(matrix_board, micro, macro, estado, jogador):
    if (estado == REGISTRA_JOGADA):
        matrix_board[int(macro, 2)-1][int(micro, 2)-1] = str(jogador)

    return matrix_board

def update_board_state(matrix_board_state, estado, macro, estado_macro):
    if (estado == REGISTRA_RESULTADO):
        matrix_board_state[int(macro, 2)-1] = estado_macro

    return matrix_board_state

def update_jogador(estado, jogador):
    if (estado == TROCA_JOGADOR):
        if jogador == 1:
            jogador = 2
        else:
            jogador = 1

    return jogador

def update_exibe_macro(estado, macro):
    if (estado == JOGA_MICRO):
        exibe_macro = macro
    elif (estado == JOGA_MACRO):
        exibe_macro = "all"
    else:
        exibe_macro = "none"
        

    return exibe_macro

# -------------------- WRITE DATA --------------------
def write_txt(jogador, exibe_macro, matrix_board, matrix_board_state, resultado_jogo):
	file = open("./jogo.txt", "w")

	file.write(f"{jogador}\n")

	file.write(f"{exibe_macro}\n")

	file.write(f"{resultado_jogo}\n")
	print(f"oieee {resultado_jogo}\n")
	
	for line in matrix_board:
		file.write(" ".join(line) + "\n")
	
	file.write("\n")

	count = 0
	line  = []
	for elem in matrix_board_state:
		line.append(elem)
		count += 1
		if count == 3:
			file.write(" ".join(line) + "\n")
			count = 0
			line = []

	file.close()
	

# ------------------------- GET DATA -------------------------
def get_txt(file):
	lines = []
	file = open(file, "rb")
	line = file.readline()
	while line:
		line = line.decode("utf-8")
		line = line.replace("\r","")
		line = line.replace("\n","")
		if line != "":
			lines.append(line)
		line = (file.readline())
	
	file.close()

	return lines

def get_elements(text):
	jogador = int(text[0])
	matrix_board = []
	matrix_board_state = []
	jogada_macro = (text[1])
	resultado_jogo = (text[2])

	if jogada_macro == "all":
		yellow_matrix = [1,1,1,1,1,1,1,1,1]
	elif jogada_macro == "none":
		yellow_matrix = [0,0,0,0,0,0,0,0,0]
	else:
		yellow_matrix = [0,0,0,0,0,0,0,0,0]
		yellow_matrix[int(jogada_macro,2)-1] = 1

	for i in range(3, 12):
		matrix_board.append(text[i].split(" "))

	for i in range(12,15):
		temp = text[i].split(" ")
		for j in range(0, 3):
			matrix_board_state.append((temp[j]))

	return jogador, yellow_matrix, matrix_board, matrix_board_state	, resultado_jogo



if not TEST:
    # ---------------- RECEIVE SERIAL DATA ----------------

    print("START RECEIVING DATA...")
    count = 0
    while True:
        if count == 0:
            count = 1
            data1 = ser.read(1)  # Read 3 bytes (24 bits)
            data1_int = int.from_bytes(data1, byteorder='big')
            data1_bin = "{:08b}".format(data1_int)
            print("data1: " + data1_bin)
        else:
            count = 0
            data2 = ser.read(1)  # Read 3 bytes (24 bits)
            data2_int = int.from_bytes(data2, byteorder='big')
            data2_bin = "{:08b}".format(data2_int)
            print("data2: " + data2_bin)
            estado, macro, micro, estado_macro, estado_jogo = split_data(data1_bin, data2_bin)
            print(estado)
            print(macro)
            print(micro)
            print(estado_macro)
            print(estado_jogo)
            
            if estado == "0000":            
                text = get_txt("reset.txt")
            else:
                text = get_txt("jogo.txt")
            jogador, yellow_matrix, matrix_board, matrix_board_state, resultado_jogo = get_elements(text)
            jogador = update_jogador(estado, jogador)
            matrix_board = update_board(matrix_board, micro, macro, estado, jogador)
            matrix_board_state = update_board_state(matrix_board_state, estado, macro, estado_macro)
            exibe_macro = update_exibe_macro(estado, macro)
            print(jogador)
            write_txt(jogador, exibe_macro, matrix_board, matrix_board_state, estado_jogo)
        


    # Close the serial port
    ser.close()

if TEST:

    print("TESTING MANUALLY...")
    count = 0
    while True:
        if count == 0:
            count = 1
            data1_int = int(input("data1: "))
            data1_bin = "{:08b}".format(data1_int)
            print("data1: " + data1_bin)
        else:
            count = 0
            data2_int = int(input("data2: "))
            data2_bin = "{:08b}".format(data2_int)
            print("data2: " + data2_bin)
            estado, macro, micro, estado_macro, estado_jogo = split_data(data1_bin, data2_bin)
            print(estado)
            print(macro)
            print(micro)
            print(estado_macro)
            print(estado_jogo)

            if estado == "0000":            
                text = get_txt("reset.txt")
            else:
                text = get_txt("jogo.txt")
            jogador, yellow_matrix, matrix_board, matrix_board_state, resultado_jogo = get_elements(text)
            jogador = update_jogador(estado, jogador)
            matrix_board = update_board(matrix_board, micro, macro, estado, jogador)
            matrix_board_state = update_board_state(matrix_board_state, estado, macro, estado_macro)
            exibe_macro = update_exibe_macro(estado, macro)
            print(jogador)
            write_txt(jogador, exibe_macro, matrix_board, matrix_board_state, estado_jogo)
