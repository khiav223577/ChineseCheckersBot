require File.expand_path('../ai_base', __FILE__)
class AI::AlphaBeta < AI::Base
  MAX_DEEP = 3
  def initialize(color_idx, players, board_states, goals, output)
    pidx = players.index(color_idx)
    [goals, players].each{|s| s.push(*s.shift(pidx)) } #rearrange the order of players
    @player_size = players.size
    @players_xys = players.map{|player_color_idx|
      board_states.each_index.select{|bidx| board_states[bidx] == player_color_idx}.map{|bidx| Board::ALL_BOARD_XY[bidx]}.shuffle
    }
    @goals_xys = goals.map{|goal| goal.map{|bidx| Board::ALL_BOARD_XY[bidx]} }
    @board_states = board_states
    @cache_rule_execs = []
    @output = output
  end
  def search
    @players_heuristic_cost = Array.new(@player_size){|i| heuristic_function(@players_xys[i], @goals_xys[i]) }
    alpha_beta(1, -INFINITY, INFINITY)
    @current_output.each_with_index{|s, idx| @output[idx] = s }
  end
  def evaluation_function
    return -(@players_heuristic_cost[0] - @players_heuristic_cost[1..-1].min)
  end
  def get_player_idx_by_depth(depth)
    return (depth - 1) % @player_size
  end
  def get_rule_obj_by(depth)
    return (@cache_rule_execs[depth - 1] ||= RuleExec.new(self, @players_xys[get_player_idx_by_depth(depth)]))
  end
private
  def alpha_beta(depth, alpha, beta)
    return evaluation_function if depth > MAX_DEEP
    player_idx = get_player_idx_by_depth(depth)
    rule_obj = get_rule_obj_by(depth)
    original_cost = @players_heuristic_cost[player_idx]
    max_node = (player_idx == 0) #find max
    current_value = (max_node ? -INFINITY : INFINITY)
    rule_obj.for_each_legal_move{|xys|
      new_cost = heuristic_function(xys, @goals_xys[player_idx])
      next if new_cost > original_cost
      @players_heuristic_cost[player_idx] = new_cost
      value = alpha_beta(depth + 1, alpha, beta)
      if max_node
        next if value <= current_value
        if (current_value = value) > alpha
          alpha = current_value
          @current_output = rule_obj.get_output if depth == 1
          next :cut if alpha > beta
        end
      else
        next if value >= current_value
        if (current_value = value) < beta
          beta = current_value
          next :cut if alpha > beta
        end
      end
    }
    @players_heuristic_cost[player_idx] = original_cost
    return evaluation_function
  end
end
