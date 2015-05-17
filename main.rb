require 'gosu'
require './board'
class ChineseCheckersWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = 'Hello'
    @board = Board.new(200, 0, 30, 20)
    @board.start_game(6)
    @message = Gosu::Image.from_text(self, 'Hello, World!', Gosu.default_font_name, 30)
  end
  def draw
    @message.draw(10, 10, 0)
    @board.draw(self)
  end
end
window = ChineseCheckersWindow.new
window.show
