module AI
  class Base
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
  end
end
