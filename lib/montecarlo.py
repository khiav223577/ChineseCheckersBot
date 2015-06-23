#from brdfunc import BrdFunc
#from brd import Brd
from board import Board
import random,json,sys,time,copy

class MonteCarlo:
    def random(self,brd):
	ans = random.choice(brd.getLegalMove(brd.color_idx,brd.board_states))
	return ans
    def expand(self,brd):
	for move in brd.getLegalMove(brd.color_idx,brd.board_states):
	    new_board = brd.toNewBoard(brd.board_states,move[0],move[-1])
	    cur_idx = brd.players.index(brd.color_idx)
	    new_color = brd.players[(cur_idx+1)%len(brd.players)]
	    tmp = Board(new_color,brd.players,new_board,brd.goals)
	    #print "old",new_color,new_board
	    #print "child",tmp.color_idx,tmp.board_states,"\n"
	    #print id(tmp),id(brd)
	    brd.child.append(tmp)
	for child in brd.child:
	    child.parent = brd

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
	    self.expand(final_brd)
	
	    #print >> sys.stderr,(final_brd.color_idx,final_brd.players)
	    #print >> sys.stderr,(final_brd.board_states)
	    #print >> sys.stderr,(len(final_brd.child))
	    #print >> sys.stderr,(final_brd.child[0].color_idx)
	    #print >> sys.stderr,(final_brd.child[0].board_states)
	    #break

	    for b in final_brd.child:
		for i in xrange(1):
		    self.Simulate(b)
	    break	
	max_winrate = -float("inf")
	for child,move in zip(brd.child,brd.getLegalMove(brd.color_idx,brd.board_states)):
	    winrate = child.Wi/child.Ni
	    if winrate > max_winrate:
		max_winrate = winrate
		ans = move

	return ans
    
    def Simulate(self,brd):
	constant_board = copy.deepcopy(brd.board_states)
	cur_color = brd.color_idx
	cur_board = brd.board_states
	cur_idx = brd.players.index(cur_color)
	player_len = len(brd.players)
	deep = 0
	while True:
	    deep += 1 
	    #print >> sys.stderr, deep
	    all_move = brd.getLegalMove(cur_color,cur_board)

	    if len(all_move) == 0:
		print >> sys.stderr,(cur_color,cur_board)
	    move = random.choice(all_move)
	    brd.toNewBoardModified(cur_board,move[0],move[-1])
	    end = True


	    #print cur_color,":",cur_board,brd.goals[cur_idx]	    


	    for goal in brd.goals[cur_idx]:
		if cur_board[goal] != cur_color:
		    end = False
		    break
	    if end:
		b = brd
		while b != None:
		    b.Ni += 1
		    if brd.color_idx == cur_color:
		    	brd.Wi += 1
		    b = b.parent
		break
	    cur_idx = (cur_idx + 1)%player_len
	    cur_color = brd.players[cur_idx]
    
	brd.board_states = constant_board
	

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

