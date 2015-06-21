module AI
  class Base
    INFINITY = 99999999
    DIRECTIONS = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, -1], [-1, 1]]
#----------------------------------
#  initialize
#----------------------------------
    def initialize
      raise %{Can't instantiate abstract class}
    end
#----------------------------------
#  ACCESS
#----------------------------------
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
#----------------------------------
#  RuleExec
#----------------------------------
    class RuleExec
      def initialize(ai_base, your_xys)
        @ai_base = ai_base
        @path_hash = {}
        @your_xys = your_xys
      end
      def for_each_legal_move(&block)
        @callback = block
        @deep = 0
        for @your_xys_idx in @your_xys.size.times
          inner_for_each_legal_move
        end
      end
      def get_output
        return @inner_output[0..@deep]
      end
    private
      def inner_for_each_legal_move
        @deep += 1
        xy = @your_xys[@your_xys_idx]
        @inner_output = [Board::BOARD_XY_TO_BOARD_INDEX_HASH[xy]] if (can_walk_a_stone = (@deep == 1))
        for (x_chg, y_chg) in DIRECTIONS.shuffle
          xy_step1 = [xy[0] + x_chg, xy[1] + y_chg]
          xy_step2 = [xy_step1[0] + x_chg , xy_step1[1] + y_chg]
          color1 = @ai_base.get_color_at(xy_step1)
          color2 = @ai_base.get_color_at(xy_step2)
          if can_walk_a_stone and color1 == 0
            @your_xys[@your_xys_idx] = xy_step1
            @inner_output[@deep] = Board::BOARD_XY_TO_BOARD_INDEX_HASH[xy_step1]
            @callback.call(@your_xys)
            @your_xys[@your_xys_idx] = xy
          end
          if color2 == 0 and color1 != nil and color1 != 0 and not @path_hash[bidx = Board::BOARD_XY_TO_BOARD_INDEX_HASH[xy_step2]]
            @path_hash[bidx] = true
            @your_xys[@your_xys_idx] = xy_step2
            @inner_output[@deep] = bidx
            @callback.call(@your_xys)
            inner_for_each_legal_move
            @inner_output[@deep] = Player::INVALID_BIDX
            @your_xys[@your_xys_idx] = xy
            @path_hash[bidx] = nil
          end
        end
        @deep -= 1
      end
    end
  end
end
