class Player
  attr_reader :color_idx
  def initialize(color_idx)
    @color_idx = color_idx
    @move_count = 0
  end
  def select_stone(stone)
    deselect_stone
    @prev_select_stone = stone
    stone.selected = true
  end
  def deselect_stone
    return if @prev_select_stone == nil
    @prev_select_stone.selected = nil
    @prev_select_stone = nil
  end
  def update(window, board) #return if a player had finished his turn
    return false if not Input.trigger?(Gosu::MsLeft)
    return false if (stone = board.get_stone_by_window_xy(window.mouse_x, window.mouse_y)) == nil
    if @prev_select_stone == nil       #select stone to move(has not selected a stone)
      return false if stone.color_idx != @color_idx #must select current player's stone
      select_stone(stone)
    elsif @prev_select_stone == stone  #cancle the selection(select the same stone)
      deselect_stone
      return finish! if @move_count > 0 #has jumpped
    elsif @prev_select_stone.color_idx == stone.color_idx #change selection(select another stone with same color)
      select_stone(stone)
    elsif not stone.occupied?             #move stone(select an available place)
      case @prev_select_stone.distance_from(stone)
      when 1 #move
        return false if @move_count > 0 #has jumpped
        stone.switch_color_with(@prev_select_stone)
        deselect_stone
        return finish!
      when 2 #jump
        middle_stone = board.get_stone_by_board_xy((stone.bx + @prev_select_stone.bx) / 2, (stone.by + @prev_select_stone.by) / 2)
        return false if not middle_stone.occupied? #must jump over another stone
        stone.switch_color_with(@prev_select_stone)
        @move_count += 1
        select_stone(stone)
      else
        #illegal movement
        #TODO show message?
      end
    end
    return false
  end
  def finish! #finish player's turn
    @move_count = 0
    return true
  end
end
