class ButtonObj
  attr_accessor :highlighted_bk_color
  attr_reader :bind_events_callback
  class << self
    def bind_as_group!(buttons)
      callback = proc{|btn|
        buttons.each{|s| s.highlighted_bk_color = nil }
        btn.highlighted_bk_color = Gosu::Color.rgba(220, 120, 120, 200)
      }
      buttons.each{|s| s.bind_events_callback << callback }
    end
  end
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
    @bind_events_callback = []
  end
  def click!
    @on_click.call(self) if @on_click
    @bind_events_callback.each{|s| s.call(self)}
  end
  def update(window)
    @x1 = @x - @width / 2
    @x2 = @x + @width / 2
    @y1 = @y - @height / 2
    @y2 = @y + @height / 2
    @in_area = (window.mouse_x.between?(@x1, @x2) and window.mouse_y.between?(@y1, @y2))
    self.click! if @in_area and Input.trigger?(Gosu::MsLeft)
  end
  def draw(window)
    @font ||= Gosu::Font.new(window, Gosu::default_font_name, 24)
    bk_color = @highlighted_bk_color || @background_color
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
    @font.draw(@text, @x - text_len * 6.4, @y - 12 , @z_index, 1.0, 1.0, @text_color)
  end
end
