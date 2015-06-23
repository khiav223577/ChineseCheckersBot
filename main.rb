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

    #----------choose the number of players----------
    @number_buttons = Hash[*Board::AVAILABLE_PLAYER_NUMBERS.map.with_index{|s, idx|
      next [s, ButtonObj.new(105, 220 + 30 * idx, 25, 25, s.to_s){ @current_select_number = s }]
    }.flatten]
    ButtonObj.bind_as_group!(@number_buttons.values)
    @number_buttons[4].click!
    #----------choose play mode----------
    @mode_buttons = [
      ButtonObj.new(50, 240, 50, 30, 'CvP'){ @current_select_mode = :CvP },
      ButtonObj.new(50, 280, 50, 30, 'CvC'){ @current_select_mode = :CvC },
      ButtonObj.new(50, 320, 50, 30, 'PvP'){ @current_select_mode = :PvP },
    ]
    ButtonObj.bind_as_group!(@mode_buttons)
    @mode_buttons[0].click!
    #----------new game button----------
    @buttons = [
      ButtonObj.new(75, 180, 120, 30, 'new game'){ @board.start_game(@current_select_mode, @current_select_number, rand(@current_select_number))},
    ]
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
    exit if Input.trigger?(Gosu::KbEscape)
    # @buttons.first.click! if @board.game.current_status == :win
    self.caption = "#{Gosu.fps} FPS - Chinese Checkers Game"
    @board.update(self)
    @buttons.each{|s| s.update(self) }
    @mode_buttons.each{|s| s.update(self) }
    @number_buttons.values.each{|s| s.update(self) }
    Input.update #must at the end of this method
  end
  def draw
    @message.draw(10, 10, 0)
    @board.draw(self)
    @buttons.each{|s| s.draw(self) }
    @mode_buttons.each{|s| s.draw(self) }
    @number_buttons.values.each{|s| s.draw(self) }
    @cursors[:normal].draw(mouse_x, mouse_y, 99999)
  end
end
window = ChineseCheckersWindow.new
window.show
