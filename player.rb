class Player
  attr_reader :color_idx
  attr_reader :goal
  def initialize(board, color_idx, goal, ai = nil)
    @board = board
    @color_idx = color_idx
    @goal = goal
    @ai = ai
    @move_count = 0
    @ai_result_size = 0
    @sleep_counter = 0
  end
#---------------------------------------------
#  (Select/Deselect) a stone
#---------------------------------------------
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
#---------------------------------------------
#  Action
#---------------------------------------------
  def play_a_action(stone)
    return :invalid if stone == nil
    if @prev_select_stone == nil       #select stone to move(has not selected a stone)
      return :cant_select_others_stone if stone.color_idx != @color_idx
      select_stone(stone)
    elsif @prev_select_stone == stone  #cancle the selection(select the same stone)
      deselect_stone
      return finish! if @move_count > 0 #has jumpped
    elsif @prev_select_stone.color_idx == stone.color_idx #change selection(select another stone with same color)
      return :illegal_movement if @move_count > 0
      select_stone(stone)
    elsif not stone.occupied?          #move stone(select an available place)
      case @prev_select_stone.distance_from(stone)
      when 1 #move
        return :you_had_jumpped if @move_count > 0
        stone.switch_color_with(@prev_select_stone)
        deselect_stone
        return finish!
      when 2 #jump
        bx = (stone.bx + @prev_select_stone.bx)
        by = (stone.by + @prev_select_stone.by)
        return :illegal_movement if bx % 2 != 0 or by % 2 != 0
        middle_stone = @board.get_stone_by_board_xy(bx / 2, by / 2)
        return :cant_jump_without_other_stone if not middle_stone.occupied?
        stone.switch_color_with(@prev_select_stone)
        @move_count += 1
        select_stone(stone)
      else
        return :illegal_movement #TODO show message?
      end
    else
      return :this_place_is_occupied
    end
    return :success
  end
  def finish! #finish player's turn
    @move_count = 0
    return :finish
  end
  def check_whether_win_the_game?
    return @goal.all?{|bidx| @board.get_stone_by_bidx(bidx).color_idx == @color_idx }
  end
#---------------------------------------------
#  Update (return :next_turn, :win, :fail, or nil)
#---------------------------------------------
  INVALID_BIDX = 999 #must be unsigned integer and larger than the largest 'color_idx'
  MAXIMUM_STEP_SIZE = 32 #maximum step number
  def update(window)
    return if @exec_ai_flag
    if @ai
      if @sleep_counter == 0
        @sleep_counter = CONFIG[:ai_sleep_time] #slow down AI's action speed
      else
        @sleep_counter -= 1
        return
      end
      if @ai_result_size == 0
        players = @board.players.map{|s| s.color_idx }
        goals   = @board.players.map{|s| s.goal }
        states  = @board.get_board_state_for_ai
        @exec_ai_flag = true
        @ai.exec_ai(@color_idx, players, states, goals, Array.new(MAXIMUM_STEP_SIZE, INVALID_BIDX)){|result|
          @exec_ai_flag = false
          ridx    = result.index(INVALID_BIDX) #delete invalid bidx
          @ai_result = (ridx ? result[0...ridx] : result).reverse
          @ai_result_size = @ai_result.size
          return :fail if @ai_result_size == 0
        }
        return
      end
      stone = @board.get_stone_by_bidx(@ai_result[@ai_result_size -= 1])
      status = play_a_action(stone)
      if @ai_result_size == 0
        status = play_a_action(stone) if status == :success
        return :fail if status != :finish
      else
        return :fail if status != :success
        return nil
      end
    else
      return if not Input.trigger?(Gosu::MsLeft)
      return if play_a_action(@board.get_stone_by_window_xy(window.mouse_x, window.mouse_y)) != :finish
    end
    return :win if check_whether_win_the_game?
    return :next_turn
  end
end
