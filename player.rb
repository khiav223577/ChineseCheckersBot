class Player
  def initialize(color_idx)
    @color_idx = color_idx
  end
  def update(window, board)
    return if not Input.trigger?(Gosu::MsLeft)
    p board.get_stone_by_window_xy(window.mouse_x, window.mouse_y)
    return
  end
end
