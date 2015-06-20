class Stone
  Z_INDEX = 10
  COLORS = [
    [Gosu::Color.new(255, 128, 128, 128), Gosu::Color.new(255, 128, 128, 128)], #gray
    [Gosu::Color.new(255, 255,   0,   0), Gosu::Color.new(255, 255, 128, 128)], #red
    [Gosu::Color.new(255, 216, 216,   0), Gosu::Color.new(255, 235, 235, 160)], #yellow
    [Gosu::Color.new(255,   0, 192,   0), Gosu::Color.new(255, 128, 223, 128)], #green
    [Gosu::Color.new(255,   0, 216, 216), Gosu::Color.new(255, 160, 235, 235)], #cyan
    [Gosu::Color.new(255,   0,   0, 255), Gosu::Color.new(255, 128, 128, 255)], #blue
    [Gosu::Color.new(255, 216,   0, 216), Gosu::Color.new(255, 235, 128, 235)], #fuchsia
  ]
  attr_writer :selected
  attr_reader :bx, :by
  def initialize(bx, by, rx, ry, size, color_idx)
    @bx = bx
    @by = by
    @rx = rx
    @ry = ry
    @size = size
    @origin_color_idx = @color_idx = color_idx
  end
#-----------------------------------
#  ACCESS
#-----------------------------------
  def color
    return @cache_color ||= (COLORS[@color_idx] || raise("illegal color_idx: #{@color_idx}")) if @color_idx != nil
    return @cache_color ||= ([Gosu::Color.new(255, 200, 200, 200), Gosu::Color.new(255, 200, 200, 200)])
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
    return false if @color_idx == 0  #gray
    return true
  end
  def release!
    self.color_idx = @origin_color_idx
  end
  def switch_color_with(other)
    self.color_idx = other.color_idx
    other.release!
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
    window.draw_square(dx, dy, @size / 2, self.color[1], Z_INDEX)
    window.draw_square(dx, dy, @size / 2 - 2, self.color.first, Z_INDEX)
  end
end
