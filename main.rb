require 'gosu'
require './input'
require './board'
class ChineseCheckersWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    @board = Board.new(320, 30, 30, 20)
    @board.start_game(3, 2)
    @message = Gosu::Image.from_text(self, 'Hello, World!', Gosu.default_font_name, 30)
  end
  def needs_cursor?
    return true
  end
#-----------------------------------
#  input
#-----------------------------------
  def button_down(id)
    Input.on_button_down(id)
  end
  def button_up(id)
    Input.on_button_up(id)
  end
#-----------------------------------
#  draw functions
#-----------------------------------
  def draw_square(cx, cy, half_size, color, z_index, rotate = 0)
    #TODO rotate
    self.draw_quad(
      cx - half_size, cy - half_size, color,
      cx + half_size, cy - half_size, color,
      cx + half_size, cy + half_size, color,
      cx - half_size, cy + half_size, color, z_index)
  end
#-----------------------------------
#  render
#-----------------------------------
  def update
    self.caption = "#{Gosu.fps} FPS - Chinese Checkers Game"
    @board.update(self)
    Input.update #must at the end of this method
  end
  def draw
    @message.draw(10, 10, 0)
    self.draw_square(20, 60, 10, @board.get_current_player_color, 10)
    @board.draw(self)
  end
end
window = ChineseCheckersWindow.new
window.show
