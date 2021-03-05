class WarRequestValidator < ActiveModel::Validator
  def validate(record)
    @start_date = record.start_date
    @end_date = record.end_date
    errors = record.errors
    if @start_date.nil? || @end_date.nil?
      errors.add(:base, "전쟁 시작일을 입력해주세요")
    elsif start_date_after_max_end_date
      errors.add(:base, "전쟁 시작일은 한달 이내로 설정해야 합니다.")
    elsif start_date_after_now
      errors.add(:base, "전쟁 시작일은 미래여야 합니다.")
    elsif end_date_after_start_date
      errors.add(:base, "전쟁 종료일은 시작일보다 미래여야 합니다.")
    end
  end

  def start_date_after_max_end_date
    @start_date > Date.today+ 31.days
  end

  def start_date_after_now
    @start_date.past?
  end

  def end_date_after_start_date
    @end_date < @start_date
  end
end