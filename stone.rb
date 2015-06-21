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
  attr_reader :rx, :ry
  def initialize(bx, by, rx, ry, size, color_idx)
    @bx = bx
    @by = by
    @rx = rx
    @ry = ry
    @size = size
    @origin_color_idx = @color_idx = color_idx
    @animation_buffer = []
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
    @animation_buffer << [[10], [@rx, @ry], [other.rx, other.ry], (self.color_idx.to_i > 0 ? self.color_idx :  other.color_idx)]
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
    need_compact_flag = false
    for ((time, xy1, xy2, color_idx),idx) in @animation_buffer.each_with_index
      time[1] = (time[1] ? time[1] : 0) + 1
      ratio = 1 - [time[1] / time[0].to_f, 1].min
      if ratio == 0
        @animation_buffer[idx] = nil
        need_compact_flag = true
      end
      color = COLORS[color_idx][0].dup
      color.alpha *= ratio * ratio
      sx = xy1[0] + offx
      sy = xy1[1] + offy
      ex = xy2[0] + offx
      ey = xy2[1] + offy
      side_vec = [ey - sy, -ex + sx]
      side_vec_len = Math.sqrt(side_vec[0] * side_vec[0] + side_vec[1] * side_vec[1])
      side_vec.map!{|s| s / side_vec_len * 3}
      window.draw_quad(
        sx + side_vec[0], sy + side_vec[1], color,
        sx - side_vec[0], sy - side_vec[1], color,
        ex - side_vec[0], ey - side_vec[1], color,
        ex + side_vec[0], ey + side_vec[1], color, Z_INDEX + 1, :additive)
      # window.draw_line(sx + offx, sy + offy, color, ex + offx, ey + offy, color, Z_INDEX + 1, :additive)
    end
    @animation_buffer.compact! if need_compact_flag
  end
end
