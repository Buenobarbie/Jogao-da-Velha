import pygame
pygame.init()

win_width = 800
win_height = 700

matrix = [0,2,1]

win = pygame.display.set_mode((win_width, win_height))
pygame.display.set_caption('Checkers')
run = True 

# CORES
global cor_amarelo 
cor_amarelo = (255,255,0)

global cor_jogador1
cor_jogador1 = (0,0,0)

global cor_jogador2
cor_jogador2 = (255,255,255)

global cor_jogador1_macro
cor_jogador1 = (0,0,0)

global cor_jogador2_macro
cor_jogador2 = (255,255,255)

global cor_empate
cor_empate = (255,255,0)

global cor_branco
cor_branco = (255, 255, 255)

global scale
scale = 1

global espacamento_macro_board
espacamento_macro_board = 8

global espacament_micro_linha
espacament_micro_linha = 2

global linha_maior 
linha_maior = 4

global linha_menor
linha_menor = 2

global quadradinho
quadradinho = 100

global x_tabuleiro
x_tabuleiro = 100

global y_tabuleiro
y_tabuleiro = 50

# tabuleiro (quadrado branco)
def draw_board():
	pygame.draw.rect(win, cor_branco, (x_tabuleiro, y_tabuleiro, size, size)) 

# titulo do jogo (Jogão da Velha)
def title():
	font_size = 70
	x_text = 150
	y_text = 20

	font_title = pygame.font.SysFont('Arial', font_size, True)
	text_title = font_title.render(f'Jogão da Velha', 1 , cor_branco)
	win.blit(text_title, (x_text, y_text))

def draw_highlight_macro():
	pass

def draw_finish_macro(matrix):
	size = 100
	i = 0
	for cel in matrix:
		i + 1
		if cel == "01":
			color = cor_jogador1_macro
		elif cel == "10":
			color = cor_jogador2_macro
		elif cel == "11":
			color = cor_empate
		else:
			draw = False

		x = i % 9 * size
		y = i % 9 * size

		if draw:
			pygame.draw.rect(win, color, (x, y, size,size))
	
def draw_board_lines(matrix):
	pass

def draw_board_plays():
	pass

def draw_player(player):
	font_size = 50
	text_color = (255,255,255)
	x_text = 20
	y_text = 20

	font1 = pygame.font.SysFont('Arial', font_size,True)
	text = font1.render(f'Jogador: {player}', 1 , text_color)
	win.blit(text, (x_text, y_text))

def draw_rect():
	pygame.draw.rect(win, (255,0,0),(20,60 , 20,10))


def draw_win():
	matrix_text = ["10", "01", "00",
				   "11", "00", "10",
				   "00", "10", "00"]
	win.fill((180,200,240))
	# draw_player(1)
	draw_board()
	pygame.display.update()

while run:
	for event in pygame.event.get():
		if event.type == pygame.QUIT:
			run= False
	
	draw_win()
	

pygame.quit()	