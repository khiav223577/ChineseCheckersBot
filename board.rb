require './stone'
class Board
  SQRT3_DIVIDE_2 = Math.sqrt(3) / 2.0
  DIVIDE_2 = 1 / 2.0
  ALL_BOARD_XY = [
    [0,0],
    [0,1],[1,0],
    [0,2],[1,1],[2,0],
    [0,3],[1,2],[2,1],[3,0],
    [-4,8],[-3,7],[-2,6],[-1,5],[0,4],[1,3],[2,2],[3,1],[4,0],[5,-1],[6,-2],[7,-3],[8,-4],
    [-3,8],[-2,7],[-1,6],[0,5],[1,4],[2,3],[3,2],[4,1],[5,0],[6,-1],[7,-2],[8,-3],
    [-2,8],[-1,7],[0,6],[1,5],[2,4],[3,3],[4,2],[5,1],[6,0],[7,-1],[8,-2],
    [-1,8],[0,7],[1,6],[2,5],[3,4],[4,3],[5,2],[6,1],[7,0],[8,-1],
    [0,8],[1,7],[2,6],[3,5],[4,4],[5,3],[6,2],[7,1],[8,0],
    [0,9],[1,8],[2,7],[3,6],[4,5],[5,4],[6,3],[7,2],[8,1],[9,0],
    [0,10],[1,9],[2,8],[3,7],[4,6],[5,5],[6,4],[7,3],[8,2],[9,1],[10,0],
    [0,11],[1,10],[2,9],[3,8],[4,7],[5,6],[6,5],[7,4],[8,3],[9,2],[10,1],[11,0],
    [0,12],[1,11],[2,10],[3,9],[4,8],[5,7],[6,6],[7,5],[8,4],[9,3],[10,2],[11,1],[12,0],
    [5,8],[6,7],[7,6],[8,5],
    [6,8],[7,7],[8,6],
    [7,8],[8,7],
    [8,8],
  ]
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
#  cooridinate system
#------------------------------------------
  def board_xy_to_real_xy(bx, by)
    rx = (bx - by) * DIVIDE_2 * @cell_distance
    ry = (bx + by) * SQRT3_DIVIDE_2 * @cell_distance
    return [rx, ry]
  end
  def real_xy_to_board_xy(rx, ry)
    x_minux_y = rx / (DIVIDE_2 * @cell_distance)
    x_plus_y = ry / (SQRT3_DIVIDE_2 * @cell_distance)
    bx = Math.round((x_plus_y + x_minux_y) / 2.0)
    by = Math.round((x_plus_y - x_minux_y) / 2.0)
    return [bx, by]
  end
#------------------------------------------
#  game control
#------------------------------------------
  def start_game(player_number)
    @stones = []
    ALL_BOARD_XY.each{|bx, by|
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
