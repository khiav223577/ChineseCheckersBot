class ButtonObj
  def initialize(x, y, width, height, text, background_color = nil, text_color = nil, &on_click)
    @x = x
    @y = y
    @z_index = 100
    @width = width
    @height = height
    @text = text
    @background_color = background_color || Gosu::Color.rgba(160, 160, 160, 200)
    @text_color = text_color || Gosu::Color.rgba(255, 255, 255, 255)
    @on_click = on_click
  end
  def update(window)
    @x1 = @x - @width / 2
    @x2 = @x + @width / 2
    @y1 = @y - @height / 2
    @y2 = @y + @height / 2
    @in_area = (window.mouse_x.between?(@x1, @x2) and window.mouse_y.between?(@y1, @y2))
    @on_click.call if @in_area and Input.trigger?(Gosu::MsLeft)
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
    @font.draw(@text, @x - text_len * 6 - 3, @y - 12 , @z_index, 1.0, 1.0, @text_color)
  end
end
