
class TournamentValidator < ActiveModel::Validator
  def validate(record)
    if record.start_date.to_date <= Date.current ||
        invalid_tournament_time?(record.tournament_time)
      record.errors.add :base, "토너먼트 생성은 내일 이후의 일정으로만 생성 가능합니다."
    end
  end

  def invalid_tournament_time?(tournament_time)
    playble_time = 9..22
    !playble_time.include?(tournament_time.hour)
  end
end