class TournamentError < StandardError
  attr_accessor :message
  def initialize(msg = "토너먼트 job 실행 중 에러가 발생했습니다.")
    @message = msg
  end
end
