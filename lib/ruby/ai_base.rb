module AI
  class Base
    INFINITY = 99999999
    DIRECTIONS = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, -1], [-1, 1]]
    def initialize
      raise %{Can't instantiate abstract class}
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
    def evaluation_function(current_xys, goal_xys)
      return current_xys.inject(0){|sum, xy|
        next sum + goal_xys.map{|gxy| get_distance_between(xy, gxy) }.min
      }
    end
  end
end
