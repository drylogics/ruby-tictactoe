class Position
  def initialize(x, y)
    @x = x
    @y = y
  end

  def x() @x; end
  def y() @y; end

  def hash
    13 * @x * @y
  end

  def eql?(other)
    equal?(other)
  end
  
  def equal?(other)
      return false if other.nil? or other.class != self.class
      if @x == other.x and @y == other.y
        return true
      else
        return false
      end
  end

  def ==(other)
    self.equal?(other)
  end

  def is_within(dimension)
    (@x > -1 and @x < dimension.length) and
    (@y > -1 and @y < dimension.breadth)
  end

end