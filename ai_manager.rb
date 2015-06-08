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
    get_distance_of = lambda{|x, y, tx, ty|
      dx = tx - x
      dy = ty - y
      next [dx.abs, dy.abs, (dx + dy).abs].max
    }
    evaluate = lambda{|your_xys, goal_xys|
      next your_xys.inject(0){|sum, xy|
        next sum + goal_xys.map{|gxy| get_distance_of.call(*xy, *gxy) }.min
      }
    }
    return AI_Object.new(nil, lambda{|color_idx, players, board_states, goal, output|
      is_available = lambda{|xy|
        next false if (bidx = Board::BOARD_XY_TO_BOARD_INDEX_HASH[xy]) == nil
        next (board_states[bidx] == 0)
      }
      goal_xys = goal.map{|bidx| Board::ALL_BOARD_XY[bidx]}
      your_xys = board_states.each_index.select{|bidx| board_states[bidx] == color_idx}.map{|bidx| Board::ALL_BOARD_XY[bidx]}
      current_min = 99999999
      your_xys.each_with_index{|xy, idx|
        for (x_chg, y_chg) in [[1, 0], [-1, 0], [0, 1], [0, -1], [1, -1], [-1, 1]]
          new_xy = [xy[0] + x_chg, xy[1] + y_chg]
          if is_available.call(new_xy)
            your_xys[idx] = new_xy
            if (min = evaluate.call(your_xys, goal_xys)) < current_min
              current_min = min
              output[0] = Board::BOARD_XY_TO_BOARD_INDEX_HASH[xy]
              output[1] = Board::BOARD_XY_TO_BOARD_INDEX_HASH[new_xy]
            end
            your_xys[idx] = xy
          end
        end
      }
    })
  end
end
