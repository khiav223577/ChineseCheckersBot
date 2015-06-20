require 'json'
require File.expand_path('../lib/core', __FILE__)
module AI_Manager
  class AI_Object
    def initialize(pre_process_type, ai_method)
      @pre_process_type = pre_process_type
      @ai_method = ai_method
    end
    def exec_ai(color_idx, *args) #args = [players, board_states, goal, output]
      case @pre_process_type
      when :pack_pointer
        @ai_method.call(color_idx, *args.map!{|s| s.pack('I*')})
        return args.last.unpack("I*")
      when :to_json
        return JSON.parse(@ai_method.call(color_idx, *args.map!{|s| s.to_json}))
      else
        @ai_method.call(color_idx, *args)
        return args.last
      end
    end
  end
module_function
  def c_hello_world_ai #test C
    return AI_Object.new(:pack_pointer, Core.method(:hello_world_ai))
  end
  def py_hello_world_ai #test python
    AI_Object.new(:to_json, lambda{|*args| %x(python lib/helloworld.py #{args.join(' ')}) })
  end
  def greedy_ai
    return AI_Object.new(nil, lambda{|*args| AI_Base.new(*args).search })
  end
end
class AI_Base
  MAX_DEEP = 30
  INFINITY = 99999999
  def initialize(color_idx, players, board_states, goal, output)
    @your_xys = board_states.each_index.select{|bidx| board_states[bidx] == color_idx}.map{|bidx| Board::ALL_BOARD_XY[bidx]}.shuffle
    @goal_xys = goal.map{|bidx| Board::ALL_BOARD_XY[bidx]}
    @board_states = board_states
    @output = output
  end
  def get_color_at(xy) #界外的話回傳nil，空格的話回傳0，否則回傳playerID
    return nil if (bidx = Board::BOARD_XY_TO_BOARD_INDEX_HASH[xy]) == nil
    return @board_states[bidx]
  end
  def get_distance_between(xy, txy)
    dx = txy[0] - xy[0]
    dy = txy[1] - xy[1]
    return [dx.abs, dy.abs, (dx + dy).abs].max
  end
  def evaluation_function(current_xys)
    return current_xys.inject(0){|sum, xy|
      next sum + @goal_xys.map{|gxy| get_distance_between(xy, gxy) }.min
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
      for (x_chg, y_chg) in [[1, 0], [-1, 0], [0, 1], [0, -1], [1, -1], [-1, 1]].shuffle
        xy_step1 = [xy[0] + x_chg, xy[1] + y_chg]
        if get_color_at(xy_step1) == 0
          @your_xys[idx] = xy_step1
          output[deep] = Board::BOARD_XY_TO_BOARD_INDEX_HASH[xy_step1]
          if (min = evaluation_function(@your_xys)) < @current_min
            @current_min = min
            @current_output = output[0..deep]
          end
          @your_xys[idx] = xy
        end
      end
    end
    for (x_chg, y_chg) in [[1, 0], [-1, 0], [0, 1], [0, -1], [1, -1], [-1, 1]].shuffle
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
          @current_output = output[0..deep]
          @current_output << @current_output.last
        end
        inner_search(idx, deep + 1, output)
        output[deep] = Player::INVALID_BIDX
        @path_hash[bidx] = nil
        @your_xys[idx] = xy
      end
    end
  end
end
