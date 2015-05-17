require 'gosu'
require './input'
require './board'
class ChineseCheckersWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = 'Hello'
    @board = Board.new(300, 20, 30, 20)
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
#  render
#-----------------------------------
  def update
    @x = Input.trigger?(Gosu::MsLeft) ? 20 : 0
    @board.update
    Input.update #must at the end of this method
  end
  def draw
    @message.draw(10 + @x, 10, 0)
    @board.draw(self)
  end
end
window = ChineseCheckersWindow.new
window.show
