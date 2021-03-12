class ServiceError < StandardError
  attr_accessor :type, :msg
  def initialize(type = :BadRequest, msg = nil)
    @type = type
    @message = nil
  end
end 
