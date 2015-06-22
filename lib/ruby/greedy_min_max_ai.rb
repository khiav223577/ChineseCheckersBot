require File.expand_path('../alpha_beta_ai', __FILE__)
class AI::GreedyMinMax < AI::AlphaBeta
  MAX_DEEP = 4
  def search
    min_max(1)
    @current_output.each_with_index{|s, idx| @output[idx] = s }
  end
private
  def min_max(depth)
    return heuristic_function(@players_xys[0], @goals_xys[0]) if depth > MAX_DEEP
    player_idx = get_player_idx_by_depth(depth)
    rule_obj = RuleExec.new(self, @players_xys[get_player_idx_by_depth(depth)])
    player_xy = @players_xys[player_idx]
    goal_xy = @goals_xys[player_idx]
    if player_idx == 0
      origin_distances = player_xy.map{|xy| get_distance_between(xy, goal_xy.first) }
      current_min = INFINITY
      rule_obj.for_each_legal_move{|xys, idx|
        next if get_distance_between(xys[idx], goal_xy.first) > origin_distances[idx]
        next if (min = min_max(depth + 1)) >= current_min
        current_min = min
        @current_output = rule_obj.get_output if depth == 1
      }
      return current_min
    else
      current_min = INFINITY
      current_min_xys = nil
      rule_obj.for_each_legal_move{|xys|
        next if (min = heuristic_function(xys, goal_xy)) >= current_min
        current_min = min
        current_min_xys = xys.clone
      }
      @players_xys[player_idx] = current_min_xys
      value = min_max(depth + 1)
      @players_xys[player_idx] = player_xy
      return value
    end
  end
end
