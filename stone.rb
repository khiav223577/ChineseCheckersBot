class Stone
  Z_INDEX = 10
  COLORS = [Gosu::Color::RED, Gosu::Color::YELLOW, Gosu::Color::GREEN, Gosu::Color::CYAN, Gosu::Color::BLUE, Gosu::Color::FUCHSIA]
  attr_accessor :x, :y
  def initialize(player_idx, x, y, size)
    @x = x
    @y = y
    @size = size
    @player_index = player_idx
    @color = COLORS[player_idx] || raise("illegal player_idx: #{player_idx}")
  end
  def draw(window)
    window.draw_quad(@x, @y, @color, @x + @size, @y, @color, @x + @size, @y + @size, @color, @x, @y + @size, @color, Z_INDEX)
  end
end
