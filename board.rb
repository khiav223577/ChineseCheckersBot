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
  ALL_PLAYER_START_AREA = [
    [0,1,2,3,4,5,6,7,8,9],
    [10,11,12,13,23,24,25,35,36,46],
    [19,20,21,22,32,33,34,44,45,55],
    [65,75,76,86,87,88,98,99,100,101],
    [74,84,85,95,96,97,107,108,109,110],
    [111,112,113,114,115,116,117,118,119,120],
  ]
=begin
               #0(0,0)
                  X
                 X X
                X X X
#10(-4,8)      X X X X    #22(8,-4)
      X X X X X X X X X X X X X
       X X X X X X X X X X X X
        X X X X X X X X X X X
         X X X X X X X X X X
 #56(0,8) X X X X X X X X X #64(8,0)
         X X X X X X X X X X
        X X X X X X X X X X X
       X X X X X X X X X X X X
      X X X X X X X X X X X X X
#98(0,12)      X X X X    #110(12,0)
                X X X
                 X X
                  X
              #120(8,8)

=end
  def initialize(x, y, cell_distance, stone_size)
    @draw_attrs = {
      :x             => x,
      :y             => y,
      :cell_distance => cell_distance,
      :stone_size    => stone_size,
    }
  end
#------------------------------------------
#  cooridinate system
#------------------------------------------
  def board_xy_to_real_xy(bx, by)
    rx = (bx - by) * DIVIDE_2 * @draw_attrs[:cell_distance]
    ry = (bx + by) * SQRT3_DIVIDE_2 * @draw_attrs[:cell_distance]
    return [rx, ry]
  end
  def real_xy_to_board_xy(rx, ry)
    x_minus_y = rx / (DIVIDE_2 * @draw_attrs[:cell_distance])
    x_plus_y = ry / (SQRT3_DIVIDE_2 * @draw_attrs[:cell_distance])
    bx = Math.round((x_plus_y + x_minus_y) / 2.0)
    by = Math.round((x_plus_y - x_minus_y) / 2.0)
    return [bx, by]
  end
#------------------------------------------
#  game control
#------------------------------------------
  def get_color_index(player_number, choose_color_idx) #get players' color
    idx = case player_number
          when 2 ; [0, 3]
          when 3 ; [0, -2, 2]
          when 4 ; [0, 1, 3, 4]
          when 6 ; [0, 1, 2, 3, 4, 5, 6]
          else   ; raise("illegal player_number: #{player_number}")
          end
    return idx.map{|s| (choose_color_idx + s) % 6 }
  end
  def get_players_start_aidx(player_number) #get players' start area
    case player_number
    when 2 ; return [5, 0]
    when 3 ; return [5, 1, 2]
    when 4 ; return [5, 4, 1, 0]
    when 6 ; return [5, 4, 3, 2, 1, 0]
    else   ; raise("illegal player_number: #{player_number}")
    end
  end
  def start_game(player_number, choose_color_idx)
    @stones = ALL_BOARD_XY.map{|bx, by| Stone.new(*board_xy_to_real_xy(bx, by), @draw_attrs[:stone_size]) }
    @player_number = player_number
    colors = get_color_index(player_number, choose_color_idx)
    ALL_PLAYER_START_AREA.each{|array| array.each{|bidx| @stones[bidx].color_idx = -1 }} #set all area to gray color
    get_players_start_aidx(player_number).each_with_index{|aidx, idx|
      color = colors[idx]
      ALL_PLAYER_START_AREA[aidx].each{|bidx| @stones[bidx].color_idx = color }
    }
  end
#------------------------------------------
#  render
#------------------------------------------
  def update
    @stones.each{|s| s.update }
  end
  def draw(window)
    @stones.each{|s| s.draw(window, @draw_attrs[:x], @draw_attrs[:y]) }
  end
end
