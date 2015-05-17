require './stone'
class Board
  SQRT3_DIVIDE_2 = Math.sqrt(3) / 2.0
  DIVIDE_2 = 1 / 2.0
=begin
              (0,0)
                X
               X X
              X X X
 (-4,8)      X X X X        (8,-4)
    X X X X X X X X X X X X X
     X X X X X X X X X X X X
      X X X X X X X X X X X
       X X X X X X X X X X
        X X X X X X X X X
       X X X X X X X X X X
      X X X X X X X X X X X
     X X X X X X X X X X X X
    X X X X X X X X X X X X X
 (0,12)      X X X X       (12,0)
              X X X
               X X
                X
              (8,8)

=end
  def initialize(x, y, cell_distance, stone_size)
    @x = x
    @y = y
    @cell_distance = cell_distance
    @stone_size = stone_size
  end
#------------------------------------------
#  cooridinate
#------------------------------------------
  def board_xy_to_real_xy(bx, by)
    rx = (bx - by) * DIVIDE_2 * @cell_distance
    ry = (bx + by) * SQRT3_DIVIDE_2 * @cell_distance
    return [rx, ry]
  end
  def real_xy_to_board_xy(rx, ry)
    x_minux_y = rx / (DIVIDE_2 * @cell_distance)
    x_plus_y = ry / (SQRT3_DIVIDE_2 * @cell_distance)
    return [(x_plus_y + x_minux_y) / 2, (x_plus_y - x_minux_y) / 2]
  end
#------------------------------------------
#  game control
#------------------------------------------
  def start_game(player_number)
    @stones = []
    [[0,0], [0,1], [1,0], [0,2], [1,1], [2, 0], [0, 3], [1, 2], [2, 1], [3, 0]].each{|bx, by|
      rx, ry = board_xy_to_real_xy(bx, by)
      @stones << Stone.new(rand(6), rx, ry, @stone_size)
    }
    @player_number = player_number
    case player_number
    when 2
    when 3
    when 4
    when 6
    else
      raise("illegal player_number: #{player_number}")
    end
  end
  def draw(window)
    @stones.each{|s| s.draw(window, @x, @y) }
  end
end
