class GroupChatMembershipError < StandardError
  attr_accessor :message, :status_code
  def initialize(message = "잘못된 요청입니다.", status_code = 400)
    @status_code = status_code
    @message = message
  end
end 
