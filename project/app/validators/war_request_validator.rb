class WarRequestValidator < ActiveModel::Validator
  def validate(record)
    @start_date = record.start_date
    @end_date = record.end_date
    @war_time = record.war_time
    errors = record.errors
    if @start_date.nil? || @end_date.nil?
      errors.add(:base, "전쟁 시작일을 입력해주세요")
    elsif start_date_after_max_start_date?
      errors.add(:base, "전쟁 시작일은 60일 이내로 설정해야 합니다.")
    elsif start_date_after_tomorrow?
      errors.add(:base, "전쟁 시작일은 내일 이후여야 합니다.")
    elsif end_date_after_start_date?
      errors.add(:base, "전쟁 종료일은 시작일 이후여야 합니다.")
    elsif end_date_after_max_end_date?
      errors.add(:base, "전쟁 종료일은 시작일 기준 7일 이내여야 합니다.")
    elsif invalid_war_time?
      errors.add(:base, "전쟁 시간은 9시부터 22시 사이여야 합니다.")
    end
  end

  def start_date_after_max_start_date?
    @start_date > Time.zone.today.midnight + 60.days
  end

  def start_date_after_tomorrow?
    @start_date < Time.zone.tomorrow.midnight
  end

  def end_date_after_start_date?
    @end_date < @start_date
  end

  def end_date_after_max_end_date?
    @end_date > @start_date + 7.days
  end

  def invalid_war_time?
    time = 9..22
    !time.include?(@war_time.hour)
  end
end