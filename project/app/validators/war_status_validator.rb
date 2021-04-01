class WarStatusValidator < ActiveModel::Validator
  def validate(record)
    guild = record.guild
    error_message = nil
    if guild.nil?
      error_message = record.position == "enemy" ? "상대 길드가 존재하지 않습니다." : "길드가 있는 유저만 전쟁을 신청 할 수 있습니다." 
    elsif guild.in_war?
      error_message = record.position == "enemy" ? "상대 길드가 진행 중인 전쟁이 있습니다." : "전쟁 중에는 전쟁 신청을 할 수 없습니다."
    elsif guild.point < record.request.bet_point
      error_message =
        record.position == "challenger" ?
          "길드 포인트 부족으로 전쟁 신청을 할 수 없습니다." :
          "상대의 길드 포인트가 부족합니다. (상대 길드 포인트: #{guild.point})"
    end
    record.errors.add(:base, message: error_message) unless error_message.nil?
  end
end