require './stone'
class Board
  STONE_SIZE = 20
=begin
              (0,0)
                X
               X X
              X X X
 (-4,8)      X X X X        (8,-4)
    X X X X X X X X X X X X X
     X X X X X X X X X X X X
      X X X X X X X X X X X
       X X X X X X X X X X
        X X X X X X X X X
       X X X X X X X X X X
      X X X X X X X X X X X
     X X X X X X X X X X X X
    X X X X X X X X X X X X X
 (0,12)      X X X X       (12,0)
              X X X
               X X
                X
              (8,8)

=end
  def initialize
    @stones = []
    6.times{|i| @stones << Stone.new(i, i * 30, i * 30, STONE_SIZE)}
  end
  def draw(window)
    @stones.each{|s| s.draw(window) }
  end
end
