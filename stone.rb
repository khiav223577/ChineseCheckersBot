class Stone
  Z_INDEX = 10
  COLORS = [Gosu::Color::RED, Gosu::Color::YELLOW, Gosu::Color::GREEN, Gosu::Color::CYAN, Gosu::Color::BLUE, Gosu::Color::FUCHSIA, Gosu::Color::GRAY]
  attr_writer :selected
  attr_reader :bx, :by
  def initialize(bx, by, rx, ry, size)
    @bx = bx
    @by = by
    @rx = rx
    @ry = ry
    @size = size
  end
#-----------------------------------
#  ACCESS
#-----------------------------------
  def color
    return @cache_color ||= (@color_idx == nil ? Gosu::Color::WHITE : (COLORS[@color_idx] || raise("illegal color_idx: #{@color_idx}")))
  end
  attr_reader :color_idx
  def color_idx=(color_idx)
    @color_idx = color_idx
    @cache_color = nil #remove cache
  end
  def ==(other)
    return false if other.class != self.class
    return false if other.bx != self.bx or other.by != self.by
    return true
  end
  def occupied? #Is this position occupies by a stone?
    return false if @color_idx == nil #white
    return false if @color_idx == -1  #gray
    return true
  end
  def switch_color_with(other)
    other.color_idx, self.color_idx = self.color_idx, other.color_idx
  end
  def distance_from(other) #get the move distance from this stone to another stone
  #TODO
    chg_x = other.bx - self.bx
    chg_y = other.by - self.by
    return [chg_x.abs, chg_y.abs, (chg_x + chg_y).abs].max
  end
#-----------------------------------
#  render
#-----------------------------------
  def update
    #TODO selected animation
    #TODO switch color animation
  end
  def draw(window, offx, offy)
    dx = offx + @rx
    dy = offy + @ry + (@selected ? -5 : 0)
    window.draw_square(dx, dy, @size / 2, self.color, Z_INDEX)
  end
end
