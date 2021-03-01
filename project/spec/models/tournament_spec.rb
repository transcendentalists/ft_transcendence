require 'rails_helper'

describe "tournament test" do
  it "overlapped_schedule test" do
    time = Time.zone.now.change(hour: 17)

    (1..15).each do |n|
      tournament_1 = create(:tournament, start_date: 5.days.after.midnight, tournament_time: time, max_user_count: 32)
      expect(tournament_1.persisted?).to eq(true)
      user = create(:user)
      tournament_1.enroll(user)
      expect(tournament_1.memberships.reload.empty?).to eq(false)

      tournament_2 = create(:tournament, start_date: n.days.after.midnight, tournament_time: time, max_user_count: 8)
      expect(tournament_2.persisted?).to eq(true)

      if n > 2 && n <= 9
        expect { tournament_2.enroll(user) }.to raise_error(StandardError, "다른 토너먼트 스케쥴과 중복됩니다.")
      else
        tournament_2.enroll(user)
        expect(tournament_2.memberships.reload.empty?).to eq(false)
      end
    end
  end



end
