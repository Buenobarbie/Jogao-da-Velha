import pygame 
import random
pygame.init()
win_width = 800
win_height = 600
win = pygame.display.set_mode((win_width, win_height))
pygame.display.set_caption("2048")
run = True 
clock = pygame.time.Clock()
board = []
nulls = []
class Space():
	
	def __init__(self , matrix):
		self.matrix = matrix
		board.append(self)
		self.value = 0
		self.size = 100
		self.x = 200 + self.matrix[1]*self.size
		self.y = 100 + self.matrix[0]*self.size

	
	def draw(self):
		pygame.draw.rect(win,(255,255,255), (self.x,self.y , self.size,self.size),2)
		pygame.draw.rect(win,self.get_color(), (self.x+5 ,self.y+5 , self.size-10,self.size-10))
		
		font1 = pygame.font.SysFont('comicsans', 50,True)
		text = font1.render(f'{self.value}', 1 ,(255,255,255))
		if self.value != 0 :
			if self.value>10:
				win.blit(text, (self.x+30, self.y+35))
			else:
				win.blit(text, (self.x+40, self.y+35))

	def get_color(self):
		if self.value == 0 :
			return (147,112,219)
		elif self.value == 2:
			return (240,250,0)
		elif self.value == 4:
			return (72,209,204)
		elif self.value == 8:
			return (255,105,180)
		elif self.value == 16:
			return (127,255,0)
		elif self.value == 32:
			return (250,0,0)
		elif self.value == 64:
			return (160,0,200)
		else:
			return (0,50,50)

def can_move_left():
	for space in board:
		if space.matrix[1] > 0 and space.value != 0 :
			previus =  get_by_matrix([space.matrix[0], space.matrix[1]-1])
			if previus.value == 0:
				return True 
			elif previus.value == space.value:
				return True
	return False 
def can_move_right():
	for space in board:
		if space.matrix[1] < 3 and space.value != 0 :
			next =  get_by_matrix([space.matrix[0], space.matrix[1]+1])
			if next.value == 0:
				return True
			elif next.value == space.value:
				return True
	return False
def can_move_up():
	for space in board:
		if space.matrix[0] > 0 and space.value != 0 :
			up =  get_by_matrix([space.matrix[0] - 1, space.matrix[1]])
			if up.value == 0:
				return True 
			elif up.value == space.value:
				return True 
	return False
def can_move_down():
	for space in board:
		if space.matrix[0] < 3 and space.value != 0:
			down =  get_by_matrix([space.matrix[0] + 1, space.matrix[1]])
			if down.value == 0:
				return True
			elif down.value == space.value:
				return True 
	return False
def can_move():
	if len(get_nulls()) == 16:
		return True
	if can_move_left() or can_move_right() or can_move_down() or can_move_up():
		return True
	else:
		return False 

def press_left():
	for space in board[::-1]:
		if space.matrix[1] > 0 :
			previus =  get_by_matrix([space.matrix[0], space.matrix[1]-1])
			if previus.value == 0:
				previus.value = space.value
				space.value = 0
			elif previus.value == space.value:
				previus.value = space.value*2
				space.value = 0
	generate()

def press_right():
	for space in board:
		if space.matrix[1] < 3 :
			next =  get_by_matrix([space.matrix[0], space.matrix[1]+1])
			if next.value == 0:
				next.value = space.value
				space.value = 0
			elif next.value == space.value:
				next.value = space.value*2
				space.value = 0
	generate()

def press_up():
	for space in board[::-1]:
		if space.matrix[0] > 0 :
			up =  get_by_matrix([space.matrix[0] - 1, space.matrix[1]])
			if up.value == 0:
				up.value = space.value
				space.value = 0
			elif up.value == space.value:
				up.value = space.value*2
				space.value = 0
	generate()

def press_down():
	for space in board:
		if space.matrix[0] < 3 :
			down =  get_by_matrix([space.matrix[0] + 1, space.matrix[1]])
			if down.value == 0:
				down.value = space.value
				space.value = 0
			elif down.value == space.value:
				down.value = space.value*2
				space.value = 0
	generate()

def get_max():
	max_value = 0
	for i in board:
		if i.value > max_value:
			max_value = i.value
	return max_value


def generate():

	new_value = 2
	if get_max() == 4:
		new_value = random.choice([2,2,2,2,4])
	elif get_max() == 8:
		new_value = random.choice([2,2,2,2,4,2,2,2,4,8])
	elif get_max() == 16:
		new_value = random.choice([2,2,2,2,4,2,2,2,4,8,2,2,2,2,4,16,8])
	elif get_max() == 32:
		new_value = random.choice([2,2,2,2,4,2,2,2,2,2,2,2,4,4,2,2,2,8,8,8,16,16,32,2])

	if get_nulls():
		random.choice(get_nulls()).value = new_value

def get_nulls():
	nulls = []
	for i in board :
		if i.value == 0:
			nulls.append(i)
	return nulls


def get_by_matrix(matrix):
	for i in board :
		if i.matrix == matrix:
			return i 

a00 = Space([0,0])
a01 = Space([0,1])
a02 = Space([0,2])
a03 = Space([0,3])
a10 = Space([1,0])
a11 = Space([1,1])
a12 = Space([1,2])
a13 = Space([1,3])
a20 = Space([2,0])
a21 = Space([2,1])
a22 = Space([2,2])
a23 = Space([2,3])
a30 = Space([3,0])
a31 = Space([3,1])
a32 = Space([3,2])
a33 = Space([3,3])

started = False
def start():
	generate()
	generate()
	
	

def draw_win():
	win.fill((255,160,122))
	for space in board:
		space.draw()
	if not started:
		pygame.draw.rect(win,(200,0,200),(win_width/2 -250,win_height/2-90,500,180))

		font1 = pygame.font.SysFont('comicsansms', 80,True)
		text = font1.render(f'Press Space ', 1 ,(255,255,255))
		text1 = font1.render(f' to start', 1 ,(255,255,255))
		win.blit(text, (win_width/2 -235, win_height/2 -100))
		win.blit(text1, (win_width/2 -170, win_height/2 -20))
	
	if not can_move():
		pygame.draw.rect(win,(200,0,200),(win_width/2 -250,win_height/2-90,500,180))
		font2 = pygame.font.SysFont('comicsansms', 80,True)
		text2 = font2.render(f'GAME ', 1 ,(255,255,255))
		text3 = font2.render(f' OVER', 1 ,(255,255,255))
		win.blit(text2, (win_width/2 -130, win_height/2 -100))
		win.blit(text3, (win_width/2 -150, win_height/2 -20))

	pygame.display.update()

can_press = 0
while run:
	clock.tick(300)
	if can_press != 0:
		can_press -=1
	

	for event in pygame.event.get():
		if event.type == pygame.QUIT:
			run = False 
	keys = pygame.key.get_pressed()
	if keys[pygame.K_SPACE] and started == False:
		start()
		started = True

	if keys[pygame.K_LEFT] and can_press == 0:
		press_left()
		can_press = 5
	if keys[pygame.K_RIGHT] and can_press == 0 :
		press_right()
		can_press = 5
	if keys[pygame.K_DOWN] and can_press == 0:
		press_down()
		can_press = 5
	if keys[pygame.K_UP] and can_press == 0:
		press_up()
		can_press = 5
	draw_win()
pygame.quit()