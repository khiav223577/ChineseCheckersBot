class Stone
  Z_INDEX = 10
  COLORS = [Gosu::Color::RED, Gosu::Color::YELLOW, Gosu::Color::GREEN, Gosu::Color::CYAN, Gosu::Color::BLUE, Gosu::Color::FUCHSIA, Gosu::Color::GRAY]
  def initialize(x, y, size)
    @x = x
    @y = y
    @size = size
  end
#-----------------------------------
#  ACCESS
#-----------------------------------
  def color
    return @cache_color ||= (@color_idx == nil ? Gosu::Color::WHITE : (COLORS[@color_idx] || raise("illegal color_idx: #{@color_idx}")))
  end
  def color_idx=(color_idx)
    @color_idx = color_idx
    @cache_color = nil #remove cache
  end
#-----------------------------------
#  render
#-----------------------------------
  def update
    #TODO animation
  end
  def draw(window, x, y)
    x += @x
    y += @y
    window.draw_quad(x, y, self.color, x + @size, y, self.color, x + @size, y + @size, self.color, x, y + @size, self.color, Z_INDEX)
  end
end
