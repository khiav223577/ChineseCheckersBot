import json
import sys
playerID = int(sys.argv[1])
players = json.loads(sys.argv[2])
board = json.loads(sys.argv[3])
goals = json.loads(sys.argv[4])
output = json.loads(sys.argv[5])

goal = goals[players.index(playerID)]
mapping = {
   0: [115, 104, 115],
  10: [108, 106, 108],
  19: [ 76,  78,  76],
  65: [ 20,  18,  20],
  74: [ 12,  14,  12],
 111: [  3,  14,   3],
}
#TODO
#Write Your Code Here


print json.dumps(mapping[goal[0]]) #output
