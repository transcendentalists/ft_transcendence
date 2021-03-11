class ServiceError < StandardError
  attr_accessor :message, :status_code
  def initialize(type = :BadRequest, msg = nil)
    @type = type
    @message = nil
  end
end 
