require 'gosu'
require File.expand_path('../input', __FILE__)
require File.expand_path('../board', __FILE__)
require File.expand_path('../ai_manager', __FILE__)
require File.expand_path('../button_obj', __FILE__)
CONFIG = {
  :ai_sleep_time => 5,
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
    @board = Board.new(320, 30, 30, 20)

    @buttons = []
    @number_buttons = []
    @current_select_number = nil
    @number_buttons.push(*[1,2,3,4,6].map.with_index{|s, idx|
      next ButtonObj.new(75, 220 + 30 * idx, 25, 25, s.to_s){|btn|
        @current_select_number = s
        @number_buttons.each{|s| s.highlighted_bk_color = nil }
        btn.highlighted_bk_color = Gosu::Color.rgba(220, 120, 120, 200)
      }
    })
    @current_select_number = 2
    @buttons << ButtonObj.new(75, 180, 120, 30, 'new game'){
      @board.start_game(@current_select_number, rand(@current_select_number))
    }
    @number_buttons[3].click!
    @buttons.first.click!

    @message = Gosu::Image.from_text(self, 'Hello, World!', Gosu.default_font_name, 32)
    @cursors = {
      :normal  => Gosu::Image.new(self, "images/cursor.png", false),
      :pointer => Gosu::Image.new(self, "images/pointer.png", false),
    }
  end
  def needs_cursor?
    return false
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
    @buttons.each{|s| s.update(self) }
    @number_buttons.each{|s| s.update(self) }
    Input.update #must at the end of this method
  end
  def draw
    @message.draw(10, 10, 0)
    @board.draw(self)
    @buttons.each{|s| s.draw(self) }
    @number_buttons.each{|s| s.draw(self) }
    @cursors[:normal].draw(mouse_x, mouse_y, 99999)
  end
end
window = ChineseCheckersWindow.new
window.show
