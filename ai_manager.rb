require File.expand_path('../lib/core', __FILE__)
module AI_Manager
  module_function
  def basicAI
    return Core.method(:basicAI)
  end
end
