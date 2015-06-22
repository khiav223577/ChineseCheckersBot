module AI
  class Base
    INFINITY = 99999999
    attr_reader :board_states
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
    def self.get_distance_between(xy, txy)
      dx = txy[0] - xy[0]
      dy = txy[1] - xy[1]
      return [dx.abs, dy.abs, (dx + dy).abs].
      max
    end
    def heuristic_function(current_xys, goal_xys)
      return current_xys.inject(0){|sum, xy|
        distance = self.class.get_distance_between(xy, goal_xys.first)
        distance /= 2 if distance <= 3 #already reach goal
        next sum + distance
      }
      return current_xys.inject(0){|sum, xy|
        next sum + goal_xys.map{|gxy| self.class.get_distance_between(xy, gxy) }.min
      }
    end
#----------------------------------
#  RuleExec
#----------------------------------
    class RuleExec
      def initialize(ai_base, your_xys, goal_xy = nil)
        @ai_base = ai_base
        @path_hash = {}
        @your_xys = your_xys
        @goal_xy = goal_xy
        @origin_distances = your_xys.map{|xy| AI::Base.get_distance_between(xy, goal_xy) } if goal_xy
      end
      def for_each_legal_move(&block)
        @callback = block
        @deep = 0
        @cut_flag = false
        for @your_xys_idx in @your_xys.size.times
          inner_for_each_legal_move
          break if @cut_flag
        end
      end
      def get_output
        return @inner_output[0..@deep]
      end
    private
      def inner_for_each_legal_move
        return if @cut_flag
        @deep += 1
        xy = @your_xys[@your_xys_idx]
        bidx = Board::BOARD_XY_TO_BOARD_INDEX_HASH[xy]
        new_bidxs = Board::NEXT_BIDX_MAPPING[bidx]
        @inner_output = [Board::BOARD_XY_TO_BOARD_INDEX_HASH[xy]] if (can_walk_a_stone = (@deep == 1))
        for dir in [0, 1, 2, 3, 4, 5].shuffle
          next if (new_bidx = new_bidxs[dir]) == nil
          color1 = @ai_base.board_states[new_bidx]
          if can_walk_a_stone and color1 == 0
            new_xy1 = Board::ALL_BOARD_XY[new_bidx]
            if @goal_xy == nil or AI::Base.get_distance_between(new_xy1, @goal_xy) <= @origin_distances[@your_xys_idx]
              @your_xys[@your_xys_idx] = new_xy1
              @inner_output[@deep] = new_bidx
              @cut_flag = (@callback.call(@your_xys) == :cut)
              @your_xys[@your_xys_idx] = xy
            end
          end
          next if color1 == nil or color1 == 0
          next if (new_bidx2 = Board::NEXT_BIDX_MAPPING[new_bidx][dir]) == nil
          color2 = @ai_base.board_states[new_bidx2]
          if color2 == 0 and not @path_hash[new_bidx2]
            new_xy2 = Board::ALL_BOARD_XY[new_bidx2]
            if @goal_xy == nil or AI::Base.get_distance_between(new_xy2, @goal_xy) <= @origin_distances[@your_xys_idx]
              @path_hash[new_bidx2] = true
              @your_xys[@your_xys_idx] = Board::ALL_BOARD_XY[new_bidx2]
              @inner_output[@deep] = new_bidx2
              @cut_flag = (@callback.call(@your_xys) == :cut)
              inner_for_each_legal_move
              @inner_output[@deep] = Player::INVALID_BIDX
              @your_xys[@your_xys_idx] = xy
              @path_hash[new_bidx2] = nil
            end
          end
          break if @cut_flag
        end
        @deep -= 1
      end
    end
  end
end
