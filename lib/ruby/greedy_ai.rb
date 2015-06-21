require File.expand_path('../ai_base', __FILE__)
class AI::Greedy < AI::Base
  MAX_DEEP = 30
  def initialize(color_idx, players, board_states, goals, output)
    @your_xys = board_states.each_index.select{|bidx| board_states[bidx] == color_idx}.map{|bidx| Board::ALL_BOARD_XY[bidx]}.shuffle
    @goal_xys = goals[players.index(color_idx)].map{|bidx| Board::ALL_BOARD_XY[bidx]}
    @board_states = board_states
    @output = output
  end
  def search
    @current_min = INFINITY
    RuleExec.new(self, @your_xys).for_each_legal_move{|deep, xys, inner_output|
      next if (min = evaluation_function(xys, @goal_xys)) >= @current_min
      @current_min = min
      @current_output = inner_output[0..deep]
    }
    @current_output.each_with_index{|s, idx| @output[idx] = s }
  end
end
