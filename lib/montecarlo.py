#from brdfunc import BrdFunc
#from brd import Brd
from board import Board
import random,json,sys,time

class MonteCarlo:
    def determine(self,brd):
	t0 = time.clock()
	"""
	while not leaf:
	    choose best PV in all node
	all_move = brd.getLegalMove(brd.color_idx,brd.board_states)
	bestPV.expand(all_move)
	"""
	while time.clock() - t0 <= 2.0:
	    final_brd = brd
	    while len(final_brd.child) != 0:
		maxx = -float("inf")
		for b in brd.child:
		    UCB = b.UCB
		    if UCB > maxx:
			maxx = UCB
			final_brd = b
	    final_brd.expand()
	    #print final_brd.child[0].parent.color_idx
	    for b in final_brd.child:
		for i in xrange(100):
		    self.Simulate(b)
	
	max_winrate = -float("inf")
	for child,move in zip(brd.child,brd.getLegalMove(brd.color_idx,brd.board_states)):
	    winrate = child.Wi/child.Ni
	    if winrate > max_winrate:
		max_winrate = winrate
		ans = move

	return ans
    
    def Simulate(self,brd):
	cur_color = brd.color_idx
	cur_board = brd.board_states
	while True:
	    print cur_color,cur_board
	    all_move = brd.getLegalMove(cur_color,cur_board)
	    move = random.choice(all_move)
	    cur_board = brd.toNewBoard(cur_board,move[0],move[-1])
	    end = True
	    for goal in brd.goals[brd.players.index(cur_color)]:
		if cur_board[goal] != cur_color:
		    end = False
		    break
	    if end == True:
		if brd.color_idx == cur_color:
		    brd.Wi += 1
		brd.Ni += 1
		b = brd
		while b.parent != None:
		    b.parent.Ni += 1
		    b = b.parent
		break
	    cur_color = brd.players[(brd.players.index(cur_color)+1)%len(brd.players)]
    

	

if __name__ == '__main__':
    playerID = int(sys.argv[1])
    players = json.loads(sys.argv[2])
    board = json.loads(sys.argv[3])
    goals = json.loads(sys.argv[4])
    output = json.loads(sys.argv[5])

    brd = Board(playerID,players,board,goals)

    AI = MonteCarlo()
    ans = AI.determine(brd)

    print json.dumps(ans) #output

