class WarRequestUpdateValidator < ActiveModel::Validator
  def validate(record)
    return if record.status == "canceled"
    @challenger = record.challenger
    @enemy = record.enemy
    @errors = record.errors
    @record = record
    validate_guilds_condition
    validate_guild_point
    validate_start_date
  end

  private
  def validate_guilds_condition
    @errors.add(:base, message: "상대 길드가 전쟁을 진행 중입니다.") if @challenger.in_war?
    @errors.add(:base, message: "이미 진행중인 전쟁이 있습니다.") if @enemy.in_war?
  end

  def validate_guild_point
    @errors.add(:bet_point, message: "길드 포인트가 부족합니다.") if @enemy.point < @record.bet_point
  end

  def validate_start_date
    calc_time = Time.zone.today <=> @record.start_date.to_date
    if calc_time == 1 || (calc_time == 0 && (Time.zone.now.hour <=> @record.war_time.hour) != -1)
      @errors.add(:start_date, message: "전쟁 시작일이 지나서 해당 전쟁이 취소되었습니다.")
    end
  end
end
