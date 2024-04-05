import pygame
pygame.init()

win_width = 800
win_height = 700

matrix = [0,2,1]

win = pygame.display.set_mode((win_width, win_height))
pygame.display.set_caption('Jogao-da-Velha')
run = True 

# CORES
global cor_title
cor_title = (0,0,0)

global cor_amarelo 
cor_amarelo = (255, 238, 125)

global cor_linha
cor_linha = (0,0,0)

global cor_jogador1
cor_jogador1 = (0,0,255)

global cor_jogador2
cor_jogador2 = (255,0,0)

global cor_jogador1_macro
cor_jogador1_macro = (0,184,230)

global cor_jogador2_macro
cor_jogador2_macro = (255,100,100)

global cor_empate
cor_empate = (255,255,0)

global cor_branco
cor_branco = (255, 255, 255)

# --------------- TAMANHOS ---------------
global scale
scale = 2

global espacamento_macro_board
espacamento_macro_board = scale * 8

global espacament_micro_linha
espacament_micro_linha = scale * 2

global linha_maior 
linha_maior = scale * 3

global linha_menor
linha_menor = scale * 2

global quadradinho
quadradinho = scale * 20

global quadrado_macro
quadrado_macro = ( 6 * espacament_micro_linha + 2 * linha_menor + 3 * quadradinho)

global x_tabuleiro
x_tabuleiro = 120

global y_tabuleiro
y_tabuleiro = 120

global tabuleiro_size
tabuleiro_size = ( 6 * espacamento_macro_board + 2 * linha_maior + 3 * quadrado_macro)

# ------------------------------ DRAW FUNCTIONS ------------------------------
# tabuleiro (quadrado branco)
def draw_board():
	size = tabuleiro_size
	pygame.draw.rect(win, cor_branco, (x_tabuleiro, y_tabuleiro, size, size)) 

# titulo do jogo (Jogão da Velha)
def title():
	font_size = 35
	x_text = 280
	y_text = 20

	font_title = pygame.font.SysFont('Arial', font_size, True)
	text_title = font_title.render(f'Jogão da Velha', 1 , cor_title)
	win.blit(text_title, (x_text, y_text))

# destaque amarelo para as macrocelulas 
def draw_highlight_macro(matrix=[1,1,1,1,1,1,1,1,1]):
	size = quadrado_macro
	i = 0
	temp = (espacamento_macro_board + quadrado_macro + espacamento_macro_board + linha_maior)

	for cel in matrix:
		if cel == 1:
			draw = True
		else:
			draw = False
 
		x = x_tabuleiro  + espacamento_macro_board + (i % 3) * temp
		y = y_tabuleiro + espacamento_macro_board +  (i // 3) * temp

		if draw:
			pygame.draw.rect(win, cor_amarelo, (x, y, size,size))
		
		i += 1

# destaque para as macrocelulas ganhas 
def draw_finish_macro(matrix):
	size = quadrado_macro
	i = 0
	temp = (espacamento_macro_board + quadrado_macro + espacamento_macro_board + linha_maior)
	
	for cel in matrix:
		draw = True
		if cel == "01":
			color = cor_jogador1_macro
		elif cel == "10":
			color = cor_jogador2_macro
		elif cel == "11":
			color = cor_empate
		else:
			draw = False
 
		x = x_tabuleiro  + espacamento_macro_board + (i % 3) * temp
		y = y_tabuleiro + espacamento_macro_board +  (i // 3) * temp

		if draw:
			pygame.draw.rect(win, color, (x, y, size,size))
		
		i += 1
	
def draw_board_lines():
	
	# Maiores
	width_maiores = linha_maior
	height_maiores = tabuleiro_size - 2 * espacamento_macro_board
	# Horizontais
	pygame.draw.rect(win, cor_linha, (x_tabuleiro + espacamento_macro_board 
								   , y_tabuleiro + 2 * espacamento_macro_board + quadrado_macro,
								     height_maiores, width_maiores))
	pygame.draw.rect(win, cor_linha, (x_tabuleiro + espacamento_macro_board 
								   , y_tabuleiro + 4 * espacamento_macro_board + 2 * quadrado_macro + linha_maior,
								     height_maiores, width_maiores))
	# Verticais
	pygame.draw.rect(win, cor_linha, (x_tabuleiro  + 2 * espacamento_macro_board + quadrado_macro
								   , y_tabuleiro   + espacamento_macro_board ,
								     width_maiores, height_maiores))
	
	pygame.draw.rect(win, cor_linha, (x_tabuleiro  + 4 * espacamento_macro_board + 2 * quadrado_macro + linha_maior
								   , y_tabuleiro  + espacamento_macro_board ,
								     width_maiores, height_maiores))
	
	temp = (espacamento_macro_board + quadrado_macro + espacamento_macro_board + linha_maior)
	# Menores
	for i in range(9):
		x_macro = x_tabuleiro  + espacamento_macro_board + (i // 3) * temp
		y_macro = y_tabuleiro + espacamento_macro_board +  (i % 3) * temp

		width_menores = linha_menor
		height_menores = quadrado_macro - 2 * espacament_micro_linha
		# Horizontais
		pygame.draw.rect(win, cor_linha, (x_macro + espacament_micro_linha 
									, y_macro + 2 * espacament_micro_linha + quadradinho,
										height_menores, width_menores))
		pygame.draw.rect(win, cor_linha, (x_macro + espacament_micro_linha 
									, y_macro + 4 * espacament_micro_linha + 2 * quadradinho + linha_menor,
										height_menores, width_menores))
		# Verticais
		pygame.draw.rect(win, cor_linha, (x_macro  + 2 * espacament_micro_linha + quadradinho
									, y_macro   + espacament_micro_linha ,
										width_menores, height_menores))
		
		pygame.draw.rect(win, cor_linha, (x_macro  + 4 * espacament_micro_linha + 2 * quadradinho + linha_menor
									, y_macro  + espacament_micro_linha ,
										width_menores, height_menores))
	




def draw_board_plays(matrix):
	size = quadradinho
	temp_macro = (espacamento_macro_board + quadrado_macro + espacamento_macro_board + linha_maior)
	temp = (espacament_micro_linha + quadradinho + espacament_micro_linha + linha_menor)
	i = 0
	for macro in matrix:
		x_macro = x_tabuleiro  + espacamento_macro_board + (i % 3) * temp_macro
		y_macro = y_tabuleiro + espacamento_macro_board +  (i // 3) * temp_macro
		i += 1
		j = 0
		for micro in macro:
			draw = True
			if micro == "1":
				color = cor_jogador1
			elif micro == "2":
				color = cor_jogador2
			else:
				draw = False

			x = x_macro  + espacament_micro_linha + (j % 3) * temp
			y = y_macro + espacament_micro_linha  +  (j // 3) * temp
			
			if draw:
				pygame.draw.rect(win, color, (x, y, size,size))
			
			j += 1

def draw_player(player):
	font_size = 25
	if player == 1:
		text_color = cor_jogador1
	else:
		text_color = cor_jogador2
	x_text = 350
	y_text = 70

	font1 = pygame.font.SysFont('Arial', font_size,True)
	text = font1.render(f'Jogador: {player}', 1 , text_color)
	win.blit(text, (x_text, y_text))

def draw_rect():
	pygame.draw.rect(win, (255,0,0),(20,60 , 20,10))

def draw_result(result):
	font_size = 100
	if result == "01":
		text_color = cor_jogador1
		text = "Jogador 1 Venceu!"
	elif result == "10":
		text_color = cor_jogador2
		text = "Jogador 2 Venceu!"
	elif result == "11":
		text_color = cor_empate
		text = "Empate!"
	x_text = 10
	y_text = 300

	font1 = pygame.font.SysFont('Arial', font_size,True)
	text = font1.render(f'{text}', 1 , text_color)
	win.blit(text, (x_text, y_text))

# ---------------------------- GET DATA ----------------------------
def get_txt():
	lines = []
	file = open("./jogo.txt", "rb")
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

# ------------------------------ DRAW WINDOW ------------------------------

def draw_win(jogador,yellow_matrix, matrix_board, matrix_board_state, resultado_jogo):
	win.fill((180,200,240))
	title()
	draw_player(jogador)
	draw_board()
	draw_highlight_macro(yellow_matrix)
	draw_finish_macro(matrix_board_state)
	draw_board_lines()
	draw_board_plays(matrix_board)
	if resultado_jogo != "00":
		draw_result(resultado_jogo)
	pygame.display.update()

while run:
	for event in pygame.event.get():
		if event.type == pygame.QUIT:
			run= False
	text = get_txt()
	jogador, yellow_matrix, matrix_board, matrix_board_state, resultado_jogo = get_elements(text)
	draw_win(jogador,yellow_matrix, matrix_board, matrix_board_state, resultado_jogo)
	

pygame.quit()	