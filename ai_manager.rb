require File.expand_path('../lib/core', __FILE__)
module AI_Manager
  class AI_Object
    def initialize(pre_process_type, ai_method)
      @pre_process_type = pre_process_type
      @ai_method = ai_method
    end
    def exec_ai(color_idx, players, board_states, goal, output)
      case @pre_process_type
      when :pack_pointer
        players      = players.pack("I*")
        board_states = board_states.pack("I*")
        output       = output.pack("I*")
        goal         = goal.pack("I*")
      end
      @ai_method.call(color_idx, players, board_states, goal, output)
      case @pre_process_type
      when :pack_pointer
        output = output.unpack("I*")
      end
      return output
    end
  end
module_function
  def hello_world_ai
    return AI_Object.new(:pack_pointer, Core.method(:hello_world_ai))
  end
  def greedy_ai
    return AI_Object.new(nil, lambda{|*args| AI_Base.new(*args).search })
  end
end
class AI_Base
  MAX_DEEP = 30
  INFINITY = 99999999
  def initialize(color_idx, players, board_states, goal, output)
    @your_xys = board_states.each_index.select{|bidx| board_states[bidx] == color_idx}.map{|bidx| Board::ALL_BOARD_XY[bidx]}
    @goal_xys = goal.map{|bidx| Board::ALL_BOARD_XY[bidx]}
    @board_states = board_states
    @output = output
  end
  def get_color_at(xy)
    return nil if (bidx = Board::BOARD_XY_TO_BOARD_INDEX_HASH[xy]) == nil
    return @board_states[bidx]
  end
  def get_distance_of(xy, txy)
    dx = txy[0] - xy[0]
    dy = txy[1] - xy[1]
    return [dx.abs, dy.abs, (dx + dy).abs].max
  end
  def evaluation_function(current_xys)
    return current_xys.inject(0){|sum, xy|
      next sum + @goal_xys.map{|gxy| get_distance_of(xy, gxy) }.min
    }
  end
  def search
    @current_min = INFINITY
    @path_hash = {}
    @your_xys.each_index{|idx| inner_search(idx) }
    @current_output.each_with_index{|s, idx| @output[idx] = s }
  end
  def inner_search(idx, deep = 1, output = nil)
    return if deep > MAX_DEEP
    xy = @your_xys[idx]
    if deep == 1
      output = [Board::BOARD_XY_TO_BOARD_INDEX_HASH[xy]]
      for (x_chg, y_chg) in [[1, 0], [-1, 0], [0, 1], [0, -1], [1, -1], [-1, 1]]
        xy_step1 = [xy[0] + x_chg, xy[1] + y_chg]
        if get_color_at(xy_step1) == 0
          @your_xys[idx] = xy_step1
          output[deep] = Board::BOARD_XY_TO_BOARD_INDEX_HASH[xy_step1]
          if (min = evaluation_function(@your_xys)) < @current_min
            @current_min = min
            @current_output = output.clone
          end
          @your_xys[idx] = xy
        end
      end
    end
    for (x_chg, y_chg) in [[1, 0], [-1, 0], [0, 1], [0, -1], [1, -1], [-1, 1]]
      xy_step1 = [xy[0] + x_chg, xy[1] + y_chg]
      xy_step2 = [xy_step1[0] + x_chg , xy_step1[1] + y_chg]
      bidx = Board::BOARD_XY_TO_BOARD_INDEX_HASH[xy_step2]
      next if @path_hash[bidx]
      if get_color_at(xy_step1).to_i != 0 and get_color_at(xy_step2) == 0
        @your_xys[idx] = xy_step2
        @path_hash[bidx] = true
        output[deep] = bidx
        if (min = evaluation_function(@your_xys)) < @current_min
          @current_min = min
          @current_output = output.clone
          @current_output << output.last
        end
        inner_search(idx, deep + 1, output)
        output[deep] = Player::INVALID_BIDX
        @path_hash[bidx] = nil
        @your_xys[idx] = xy
      end
    end
  end
end
