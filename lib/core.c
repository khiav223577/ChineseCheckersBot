#include "math.h"
#include <stdio.h>
#include <stdlib.h>
#include "memory.h"
int sum(int num1, int num2, int num3[2]){ //test
  return num1 + num2 + num3[0] + num3[1];
}
/*
playerID: 一個數字(正整數)，代表當前是哪個player要動作。
players: 一個陣列，代表所有的player的ID以及其順序。例如：[1,3,7]代表有三個玩家，順序是1 => 3 => 7 => 1 => ,,,
board: 一個長度為121的陣列，代表整個盤面。0的話是空格，其它數字代表其玩家的棋子。
goals: 一個二維陣列，每個元素都是players目標要走到的區域。例如[0,1,2,3,4,5,6,7,8,9]代表盤面最下面的玩家目標是盤面最上方的那十個點。
output: 回傳要走的順序。用bidx表示
*/
void hello_world_ai(unsigned int playerID, unsigned int players[], unsigned int board[121], unsigned int goals[][10], unsigned int output[32]){
  int player_idx = 0;
  while(players[player_idx] != playerID) player_idx += 1;
  unsigned int *goal = goals[player_idx];
  switch(goal[0]){
  case 0:{
    output[0] = 115;
    output[1] = 104;
    output[2] = 115;   
    break;}
  case 10:{
    output[0] = 108;
    output[1] = 106;
    output[2] = 108;
    break;}
  case 19:{
    output[0] = 76;
    output[1] = 78;
    output[2] = 76;
    break;}
  case 65:{
    output[0] = 20;
    output[1] = 18;
    output[2] = 20;
    break;}
  case 74:{
    output[0] = 12;
    output[1] = 14;
    output[2] = 12;
    break;}
  case 111:{
    output[0] = 3;
    output[1] = 14;
    output[2] = 3;
    break;}
  }
}
