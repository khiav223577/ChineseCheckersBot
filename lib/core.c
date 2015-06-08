#include "math.h"
#include <stdlib.h>
#include "memory.h"
int sum(int num1, int num2, int num3[2]){ //test
  return num1 + num2 + num3[0] + num3[1];
}
/*
playerIdx: 一個數字，代表當前是哪個player要動作
players: 一個陣列，代表所有的player的ID以及其順序。例如：[1,3,7]代表有三個玩家，順序是1 => 3 => 7 => 1 => ,,,
board: 一個陣列，代表整個盤面。0的話是空格，其它數字代表其玩家的棋子
goal: 當前player目標要走到的區域
output: 回傳要走的順序。
*/
void hello_world_ai(unsigned int playerID, unsigned int *players, unsigned int board[121], unsigned int *goal, unsigned int output[32]){
  output[0] = 115;
  output[1] = 104;
  output[2] = 115;
  output[3] = 115;
}
