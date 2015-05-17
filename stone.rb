class Stone
  Z_INDEX = 10
  COLORS = [Gosu::Color::RED, Gosu::Color::YELLOW, Gosu::Color::GREEN, Gosu::Color::CYAN, Gosu::Color::BLUE, Gosu::Color::FUCHSIA]
  def initialize(x, y, size)
    @x = x
    @y = y
    @size = size
  end
#-----------------------------------
#  ACCESS
#-----------------------------------
  def color
    return @cache_color ||= (@player_idx == nil ? Gosu::Color::WHITE : (COLORS[@player_idx] || raise("illegal player_idx: #{@player_idx}")))
  end
  def player_idx=(player_idx)
    @player_idx = player_idx
    @cache_color = nil #remove cache
  end
#-----------------------------------
#  render
#-----------------------------------
  def draw(window, x, y)
    x += @x
    y += @y
    window.draw_quad(x, y, self.color, x + @size, y, self.color, x + @size, y + @size, self.color, x, y + @size, self.color, Z_INDEX)
  end
end
