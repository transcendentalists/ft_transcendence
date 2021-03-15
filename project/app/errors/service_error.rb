class ServiceError < StandardError
  attr_reader :type, :message

  def initialize(type = :BadRequest, msg = nil)
    @type = type
    @message = nil
  end
end
