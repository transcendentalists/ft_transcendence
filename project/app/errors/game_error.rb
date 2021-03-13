class GameError < StandardError
  def initialize(type = :STOP)
    @type = type
  end

  def type
    return @type
  end
end 
