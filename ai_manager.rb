require File.expand_path('../lib/core', __FILE__)
module AI_Manager
  class AI_Object
    def initialize(pre_process_type, ai_method)
      @pre_process_type = pre_process_type
      @ai_method = ai_method
    end
    def exec_ai(color_idx, players, states, goal, result)
      case @pre_process_type
      when :pack_pointer
        players = players.pack("I*")
        states  = states.pack("I*")
        result  = result.pack("I*")
        goal    = goal.pack("I*")
      end
      @ai_method.call(color_idx, players, states, goal, result)
      case @pre_process_type
      when :pack_pointer
        result = result.unpack("I*")
      end
      return result
    end
  end
  module_function
  def hello_world_ai
    return AI_Object.new(:pack_pointer, Core.method(:hello_world_ai))
  end
  def greedy_ai #@color_idx, players, states, @goal.pack("I*"), result
    return AI_Object.new(nil, lambda{|color_idx, players, states|

    })
  end
end
