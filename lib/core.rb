require 'dl'
require 'dl/import'
module Core
  extend DL::Importer
  dlload File.expand_path('../core.dll', __FILE__)
  extern 'int sum(int, int, int*)'
end
#Test
p Core.sum(1,5,[100,512].pack("i*"))
