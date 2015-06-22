require 'json'
require File.expand_path('../lib/core', __FILE__)
require File.expand_path('../lib/ruby/greedy_ai', __FILE__)
require File.expand_path('../lib/ruby/alpha_beta_ai', __FILE__)
require File.expand_path('../lib/ruby/greedy_min_max_ai', __FILE__)
module AI_Manager
  class AI_Object
    def initialize(pre_process_type, ai_method)
      @pre_process_type = pre_process_type
      @ai_method = ai_method
    end
    def exec_ai(color_idx, *args) #args = [players, board_states, goals, output]
      Thread.new{
        t = Time.now
        case @pre_process_type
        when :pack_pointer
          args[2] = args[2].flatten
          @ai_method.call(color_idx, *args.map!{|s| s.pack('I*')})
          yield(args.last.unpack("I*"))
        when :to_json
          yield(JSON.parse(@ai_method.call(color_idx, *args.map!{|s| s.to_json})))
        else
          @ai_method.call(color_idx, *args)
          yield(args.last)
        end
        puts "%6.1fms" % ((Time.now - t) * 1000)
      }
    end
  end
module_function
  def c_hello_world_ai #test C
    return AI_Object.new(:pack_pointer, Core.method(:hello_world_ai))
  end
  def py_hello_world_ai #test python
    AI_Object.new(:to_json, lambda{|*args| %x(python #{File.expand_path('../lib/helloworld.py', __FILE__)} #{args.join(' ')}) })
  end
  def greedy_ai
    return AI_Object.new(nil, lambda{|*args| AI::Greedy.new(*args).search })
  end
  def alpha_beta_ai
    return AI_Object.new(nil, lambda{|*args| AI::AlphaBeta.new(*args).search })
  end
  def greedy_min_max_ai
    return AI_Object.new(nil, lambda{|*args| AI::GreedyMinMax.new(*args).search })
  end
end
