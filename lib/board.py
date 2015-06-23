import sys,copy,math

class Board:
    def __init__(self,playerID,players,board,goals):
	self.color_idx = playerID #1
	self.players = players #[1,2,3]
	self.board_states = board #[0 for x in xrange(121)]
	self.goals = goals #[[111,112,113,114,115,116,117,118,119,120],...]
	"""
	self.color_idx = 1
	self.players = [1,2]
	self.board_states = [0 for x in xrange(121)]
	self.goals = [[0,1,2,3,4,5,6,7,8,9,10],[ 10, 23, 11, 35, 24, 12, 46, 36, 25, 13]]
	"""
	self.parent = None
	self.child = []
	self.Wi = 0.
	self.Ni = 0.
	self.c = 0.8
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
	"""
	for i in xrange(121):
	    if i in [111,112,113,114,115,116,117,118,119,120]:
		self.board_states[i] = 1
	    elif i in [110, 97,109, 85, 96,108, 74, 84, 95,107]:
		self.board_states[i] = 2
	    else: 
		self.board = 0
	"""
    def expand(self):
	for move in self.getLegalMove(self.color_idx,self.board_states):
	    new_board = self.toNewBoard(self.board_states,move[0],move[-1])
	    cur_idx = self.players.index(self.color_idx)
	    new_color = self.players[(cur_idx+1)%len(self.players)]
	    #tmp = Board(new_color,self.players,copy.deepcopy(new_board),self.goals)
	    self.tmp = self.__class__(None,None,None,None)
	    #print "old",new_color,new_board
	    #print "child",self.tmp.color_idx,self.tmp.board_states,'\n'
	    self.child.append(copy.deepcopy(self.tmp))
	for child in self.child:
	    #print >> sys.stderr,(type(child))
	    child.parent = self

    def UCB(self):
	return self.Wi/self.Ni+self.c*math.sqrt(math.log(self.parent.Ni)/self.Ni)

    def getLegalMove(self,color,board):
	all_step = []
	mychecker = self.getPlayerChecker(board,color)
	walksteps = [[1,0],[0,1],[-1,0],[0,-1],[1,-1],[-1,1]]
	deep_goalX = self.goals[self.players.index(color)][0]
	deep_goalXY = self.XtoXY(deep_goalX)
	for checkerX in mychecker:
	    checkerXY = self.XtoXY(checkerX)
	    #walk
	    for walkstep in walksteps:
		newstepXY = [x+y for x,y in zip(checkerXY,walkstep)]
		if newstepXY not in self.ALL_BOARD_XY:
		    continue
		newstepX = self.XYtoX(newstepXY)
		if board[newstepX] == 0:
			new_board = self.toNewBoard(board,checkerX,newstepX)
			if self.approachGoal(new_board,checkerXY,newstepXY,deep_goalXY):
			    move = [checkerX, newstepX]
			    all_step.append(move)
	    #jump
	    cur_move = [checkerX]
	    all_boardhash = set([hash(str(board))])
	    self.getJumpStep(all_step,color,cur_move,board,checkerX,all_boardhash,deep_goalXY)
	#print all_step
	    #print color,board
	    #print >> sys.stderr,("no step",color,board)
	#print >> sys.stderr,(all_step)
	return all_step    

    def getJumpStep(self,all_step,color,cur_move,board,checkerX,all_boardhash,deep_goalXY):
	jumpsteps = [[2,0],[0,2],[-2,0],[0,-2],[2,-2],[-2,2]]
	checkerXY = self.XtoXY(checkerX)
	for jumpstep in jumpsteps:
	    newstepXY = [x+y for x,y in zip(checkerXY,jumpstep)]
	    middle = [int(x+y/2) for x,y in zip(checkerXY,jumpstep)]
	    if newstepXY not in self.ALL_BOARD_XY or middle not in self.ALL_BOARD_XY:
		continue
	    newstepX = self.XYtoX(newstepXY)
	    middleX = self.XYtoX(middle)
	    if board[newstepX] == 0 and board[middleX] != 0:
		new_move = cur_move + [newstepX]
		new_board = self.toNewBoard(board,checkerX,newstepX)
		new_boardhash = hash(str(new_board))
		if new_boardhash in all_boardhash:
		    continue
		if self.approachGoal(new_board,checkerXY,newstepXY,deep_goalXY):
		    all_step.append(new_move)
		all_boardhash.add(new_boardhash)
		self.getJumpStep(all_step,color,new_move,new_board,newstepX,all_boardhash,deep_goalXY)

    def approachGoal(self,board,start,dest,goal):
	sdx = start[0] - goal[0]
	sdy = start[1] - goal[1]
	sd = max(abs(sdx),abs(sdy),abs(sdx+sdy))

	ddx = dest[0] - goal[0]
	ddy = dest[1] - goal[1]
	dd = max(abs(ddx),abs(ddy),abs(ddx+ddy))

	goalarea = None
	goalX = self.XYtoX(goal)	
	for g in self.goals:
	    if goalX in g:
		goalarea = g
		break
	if goalarea == None:
		#print >> sys.stderr,("empty")
		goalarea = [0]
	fill = True
	for pos in goalarea:
	    if board[pos] == 0:
	    	fill = False
	if fill:
	    return (dd <= sd) or (dd <= 3)
	else:
	    return (dd < sd) or (dd <= 3)
	   
	
	
    def toNewBoardModified(self,brd,cur,dest):
	brd[dest] = brd[cur]
	brd[cur] = 0

    def toNewBoard(self,board,cur,dest):
	brd = copy.deepcopy(board)
	brd[dest] = brd[cur]
	brd[cur] = 0
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


