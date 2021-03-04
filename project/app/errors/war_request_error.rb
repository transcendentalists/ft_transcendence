class WarRequestError < StandardError
  attr_accessor :message, :status_code
  def initialize(message, status_code = 400)
    @status_code = status_code
    @message = message
  end
end