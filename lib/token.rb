class Token

  def initialize(id)
    @id = id
  end 

  def id() @id; end
  

  def hash
    return 61 * self.class.hash * id
  end
  def eql?(other)
    return false if other.nil? or other.class != self.class
    if other.id == @id
      return true
    else
      return false
    end
  end

  
  def ==(o) self.eql?(o); end

  def to_s() "Player-#{id}"; end


end