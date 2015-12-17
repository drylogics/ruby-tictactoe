class Dimension
  def initialize(length, breadth)
    @length = length
    @breadth = breadth
  end

  def length() @length; end
  def breadth() @breadth; end

  def hash
    13 * @length * @breadth
  end

  def eql?(other)
      return false if other.nil? or other.class != self.class
      if @length == other.length and @breadth == other.breadth
        return true
      else
        return false
      end
  end

  def ==(other)
    self.eql?(other)
  end

  def rows
    @breadth.times.collect do |row_index|
      @length.times.collect do |col_index|
        Position.new(row_index, col_index)
      end
    end
  end

end