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
    @path_hash = {}
    @your_xys.each_index{|idx| inner_search(idx) }
    @current_output.each_with_index{|s, idx| @output[idx] = s }
  end
private
  def inner_search(idx, deep = 1)
    return if deep > MAX_DEEP
    xy = @your_xys[idx]
    @inner_output = [Board::BOARD_XY_TO_BOARD_INDEX_HASH[xy]] if (can_walk_a_stone = (deep == 1))
    check_min = lambda{
      next if (min = evaluation_function(@your_xys, @goal_xys)) >= @current_min
      @current_min = min
      @current_output = @inner_output[0..deep]
    }
    for (x_chg, y_chg) in DIRECTIONS.shuffle
      xy_step1 = [xy[0] + x_chg, xy[1] + y_chg]
      xy_step2 = [xy_step1[0] + x_chg , xy_step1[1] + y_chg]
      color1 = get_color_at(xy_step1)
      color2 = get_color_at(xy_step2)
      if can_walk_a_stone and color1 == 0
        @your_xys[idx] = xy_step1
        @inner_output[deep] = Board::BOARD_XY_TO_BOARD_INDEX_HASH[xy_step1]
        check_min.call
        @your_xys[idx] = xy
      end
      if color2 == 0 and color1 != nil and color1 != 0 and not @path_hash[bidx = Board::BOARD_XY_TO_BOARD_INDEX_HASH[xy_step2]]
        @path_hash[bidx] = true
        @your_xys[idx] = xy_step2
        @inner_output[deep] = bidx
        check_min.call
        inner_search(idx, deep + 1)
        @inner_output[deep] = Player::INVALID_BIDX
        @your_xys[idx] = xy
        @path_hash[bidx] = nil
      end
    end
  end
end
