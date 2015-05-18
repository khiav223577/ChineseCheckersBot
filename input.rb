class Input
  @counter = 0
  @key_status = {}
  class << self
  private
    def get_status(id)
      status = @key_status[id]
      return nil if status == nil
      return @counter - status
    end
  public
    def on_button_down(id)
      @key_status[id] = @counter
    end
    def on_button_up(id)
      @key_status.delete(id)
    end
    def update
      @counter += 1
    end
#-----------------------------------
#  ACCESS
#-----------------------------------
    def trigger?(id)
      return (get_status(id) == 0) #第一次按下時成立
    end
    def press?(id)
      return @key_status[id] != nil #只要有按下就成立
    end
    def repeat?(id, first = 23, span = 5)
      status = get_status(id)
      return false if status == nil
      return true if status == 0
      return false if status < first
      return ((status - first) % span == 0)
    end
  end
end
