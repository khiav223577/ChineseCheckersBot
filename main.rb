require 'gosu'
require './stone'
class ChineseCheckersWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = 'Hello'
    @stones = []
    6.times{|i| @stones << Stone.new(i, i * 30, i * 30)}
    @message = Gosu::Image.from_text(self, 'Hello, World!', Gosu.default_font_name, 30)
  end
  def draw
    @message.draw(10, 10, 0)
    @stones.each{|s| s.draw(self) }
  end
end
window = ChineseCheckersWindow.new
window.show
