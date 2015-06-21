require File.expand_path('../ai_base', __FILE__)
class AI::AlphaBeta < AI::Base
  MAX_DEEP = 6
  def initialize(color_idx, players, board_states, goals, output)
    pidx = players.index(color_idx)
    [goals, players].each{|s| s.push(*s.shift(pidx)) }
    @player_size = players.size
    @players_xys = players.map{|player_color_idx|
      board_states.each_index.select{|bidx| board_states[bidx] == player_color_idx}.map{|bidx| Board::ALL_BOARD_XY[bidx]}.shuffle
    }
    @goals_xys = goals.map{|goal| goal.map{|bidx| Board::ALL_BOARD_XY[bidx]} }
    @board_states = board_states
    @output = output
  end
  def search

  end
private
  def alpha_beta(player_idx, depth, alpha, beta)
    return if depth > MAX_DEEP
    player_idx = 0 if player_idx >= @player_size
  end
end
