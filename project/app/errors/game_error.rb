class GameError < StandardError
  attr_reader :type

  def initialize(type = :STOP)
    @type = type
  end
end 
