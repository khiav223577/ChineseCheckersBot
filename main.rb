require 'gosu'
require File.expand_path('../input', __FILE__)
require File.expand_path('../board', __FILE__)
require File.expand_path('../ai_manager', __FILE__)
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
    @board.start_game(4, 2)
    @start_game_btn = ButtonObj.new(60, 180, 90, 30, '新遊戲')
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
    @start_game_btn.update(self)
    Input.update #must at the end of this method
  end
  def draw
    @message.draw(10, 10, 0)
    @board.draw(self)
    @start_game_btn.draw(self)
    @cursors[:normal].draw(mouse_x, mouse_y, 99999)
  end
end
class ButtonObj
  def initialize(x, y, width, height, text, background_color = nil, text_color = nil, &block)
    @x = x
    @y = y
    @width = width
    @height = height
    @text = text
    @background_color = background_color || Gosu::Color.rgba(160, 160, 160, 200)
    @text_color = text_color || Gosu::Color.rgba(255, 255, 255, 255)
    @z_index = 100
  end
  def update(window)
    @x1 = @x - @width / 2
    @x2 = @x + @width / 2
    @y1 = @y - @height / 2
    @y2 = @y + @height / 2
    @in_area = (window.mouse_x.between?(@x1, @x2) and window.mouse_y.between?(@y1, @y2))
    if @in_area and Input.trigger?(Gosu::MsLeft)

    end
  end
  def draw(window)
    @font ||= Gosu::Font.new(window, Gosu::default_font_name, 24)
    bk_color = @background_color
    if @in_area
      bk_color = bk_color.dup
      bk_color.filter_by_tint(255, 255, 255, 0.3)
    end
    window.draw_quad(
      @x1, @y1, bk_color,
      @x2, @y1, bk_color,
      @x2, @y2, bk_color,
      @x1, @y2, bk_color, @z_index)
    text_len = @text.size
    @font.draw(@text, @x - text_len * 10, @y - 12 , @z_index, 1.0, 1.0, @text_color)
  end
end
window = ChineseCheckersWindow.new
window.show
