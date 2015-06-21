import sys,copy

class Board:
    def __init__(self):
	self.color_idx = 1
	self.players = [1,2,3]
	self.board_states = [0 for x in xrange(121)]
	self.goal = [111,112,113,114,115,116,117,118,119,120]
	self.ALL_BOARD_XY = [
	    [0,0],
	    [0,1],[1,0],
	    [0,2],[1,1],[2,0],
	    [0,3],[1,2],[2,1],[3,0],
	    [-4,8],[-3,7],[-2,6],[-1,5],[0,4],[1,3],[2,2],[3,1],[4,0],[5,-1],[6,-2],[7,-3],[8,-4],
	    [-3,8],[-2,7],[-1,6],[0,5],[1,4],[2,3],[3,2],[4,1],[5,0],[6,-1],[7,-2],[8,-3],
	    [-2,8],[-1,7],[0,6],[1,5],[2,4],[3,3],[4,2],[5,1],[6,0],[7,-1],[8,-2],
	    [-1,8],[0,7],[1,6],[2,5],[3,4],[4,3],[5,2],[6,1],[7,0],[8,-1],
	    [0,8],[1,7],[2,6],[3,5],[4,4],[5,3],[6,2],[7,1],[8,0],
	    [0,9],[1,8],[2,7],[3,6],[4,5],[5,4],[6,3],[7,2],[8,1],[9,0],
	    [0,10],[1,9],[2,8],[3,7],[4,6],[5,5],[6,4],[7,3],[8,2],[9,1],[10,0],
	    [0,11],[1,10],[2,9],[3,8],[4,7],[5,6],[6,5],[7,4],[8,3],[9,2],[10,1],[11,0],
	    [0,12],[1,11],[2,10],[3,9],[4,8],[5,7],[6,6],[7,5],[8,4],[9,3],[10,2],[11,1],[12,0],
	    [5,8],[6,7],[7,6],[8,5],
	    [6,8],[7,7],[8,6],
	    [7,8],[8,7], 
	    [8,8]
	]

	for i in xrange(121):
	    if i <= 9:
		self.board_states[i] = 1
	    elif i in [10,11,12,13,23,24,25,35,36,46]:
		self.board_states[i] = 2
	    else: 
		self.board = 0

    def getLeagalMove(self,color,board):
	all_step = []
	mychecker = self.getPlayerChecker(board,color)
	walksteps = [[1,0],[0,1],[-1,0],[0,-1],[1,1],[-1,-1]]
	for checker in mychecker:
	    checkerXY = self.XtoXY(checker)
	    #walk
	    for walkstep in walksteps:
		newstep = [x+y for x,y in zip(checkerXY,walkstep)]
		if newstep not in self.ALL_BOARD_XY:
		    continue
		newstepX = self.XYtoX(newstep)
		if board[newstepX] == 0:
		    move = [checker, newstepX]
		    #new_board = self.toNewBoard(color,board,checker,newstepX)
		    all_step.append(move)
	    
	    #jump
	    cur_move = [checker]
	    all_boardhash = set([hash(board)])
	    self.getJumpStep(all_step,color,cur_move,board,checker,all_boardhash)
    
    def getJumpStep(all_step,color,cur_move,board,checker,all_boardhash):
	jumpsteps = [[2,0],[0,2],[-2,0],[0,-2],[2,2],[-2,-2]]
	checkerXY = self.XtoXY(checker)
	for jumpstep in jumpsteps:
	    newstep = [x+y for x,y in zip(checkerXY,jumpstep)]
	    middle = [int(x+y/2) for x,y in zip(checkerXY,jumpstep)]
	    if newstep not in self.ALL_BOARD_XY or middle not in self.ALL_BOARD_XY:
		continue
	    newstepX = self.XYtoX(newstep)
	    middleX = self.XYtoX(middle)
	    if board[newstepX] == 0 and board[middleX] != 0:
		new_move = cur_move + [newstepX]
		new_board = self.toNewBoard(color,board,checker,newstepX)
		new_boardhash = hash(new_board)
		if new_boardhash in all_boardhash:
		    continue
		all_step.append(new_move)
		all_boardhash.add(new_boardhash)
		getJumpStep(all_step,color,new_move,new_board,newstepX,all_boardhash)

		

	    



    def toNewBoard(self,color,board,cur,dest)
	brd = copy.copy(board)
	brd[cur] = 0
	brd[dest] = color
	return brd



    def getPlayerChecker(self,board,color):
	alist = []
	for i in xrange(121):
	    if board[i] == color:
		alist.append(i)
	return alist

    def XtoXY(self,X):
	return self.ALL_BOARD_XY[X]

    def XYtoX(self,XY):
	return self.ALL_BOARD_XY.index(XY)


if __name__ == "__main__":
    ChineseCheckers = Board()
