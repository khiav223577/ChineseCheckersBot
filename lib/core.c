#include "math.h"
#include <stdlib.h>
#include "memory.h"
int sum(int num1, int num2, int num3[2]){ //test
  return num1 + num2 + num3[0] + num3[1];
}
/*
playerID: 一個數字(正整數)，代表當前是哪個player要動作。
players: 一個陣列，代表所有的player的ID以及其順序。例如：[1,3,7]代表有三個玩家，順序是1 => 3 => 7 => 1 => ,,,
board: 一個長度為121的陣列，代表整個盤面。0的話是空格，其它數字代表其玩家的棋子。
goal: 當前player目標要走到的區域。例如[0,1,2,3,4,5,6,7,8,9]代表盤面最下面的玩家目標是盤面最上方的那十個點。
output: 回傳要走的順序。用bidx表示
*/
void hello_world_ai(unsigned int playerID, unsigned int *players, unsigned int board[121], unsigned int *goal, unsigned int output[32]){
  output[0] = 115;
  output[1] = 104;
  output[2] = 115;
  output[3] = 115;
}
