require 'dl'
require 'dl/import'
module Core
  extend DL::Importer
  dlload File.expand_path('../core.dll', __FILE__)
  extern 'int sum(int, int, int*)'
  extern 'void basicAI(unsigned int, unsigned int *, unsigned int *, unsigned int *, unsigned int *)'
end
#Test
a = Core.method(:sum)
p a.call(1,5,[100,512].pack("i*"))
