require 'gosu'
require File.expand_path('../input', __FILE__)
require File.expand_path('../board', __FILE__)
require File.expand_path('../ai_manager', __FILE__)
CONFIG = {
  :ai_sleep_time => 10,
}
ARGV.each{|s|
  case s
  when /^-debug=(.)$/ ; CONFIG[:ai_sleep_time] = 0 if $1.to_i != 0
  when /^-sleep=(\d+)$/ ; CONFIG[:ai_sleep_time] = $1.to_i
  end
}
class ChineseCheckersWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    @board = Board.new(280, 30, 30, 20)
    @board.start_game(3, 2)
    @message = Gosu::Image.from_text(self, 'Hello, World!', Gosu.default_font_name, 32)
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
    @board.draw(self)
  end
end
window = ChineseCheckersWindow.new
window.show
