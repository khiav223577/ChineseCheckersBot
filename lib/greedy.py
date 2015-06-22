from board import Board
import random,json,sys

class Greedy:
    #def __init__(self):

    def determine(self,brd):
	all_move = brd.getLegalMove(brd.color_idx,brd.board_states)
	#print all_move
	ans = random.choice(all_move)
	return ans


if __name__ == '__main__':
    playerID = int(sys.argv[1])
    players = json.loads(sys.argv[2])
    board = json.loads(sys.argv[3])
    goals = json.loads(sys.argv[4])
    output = json.loads(sys.argv[5])

    brd = Board(playerID,players,board,goals)
    AI = Greedy()
    
    ans = AI.determine(brd)

    print json.dumps(mapping[ans]) #output

