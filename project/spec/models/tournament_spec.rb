require 'rails_helper'

describe "tournament test" do
  # it "overlapped_schedule test" do
  #   time = Time.zone.now.change(hour: 17)

  #   (1..15).each do |n|
  #     tournament_1 = create(:tournament, start_date: 5.days.after.midnight, tournament_time: time, max_user_count: 32)
  #     expect(tournament_1.persisted?).to eq(true)
  #     user = create(:user)
  #     tournament_1.enroll(user)
  #     expect(tournament_1.memberships.reload.empty?).to eq(false)

  #     tournament_2 = create(:tournament, start_date: n.days.after.midnight, tournament_time: time, max_user_count: 8)
  #     expect(tournament_2.persisted?).to eq(true)

  #     if n > 2 && n <= 9
  #       expect { tournament_2.enroll(user) }.to raise_error(StandardError, "다른 토너먼트 스케쥴과 중복됩니다.")
  #     else
  #       tournament_2.enroll(user)
  #       expect(tournament_2.memberships.reload.empty?).to eq(false)
  #     end
  #   end
  # end

  it "can be created by web_owner or web_admin" do
    current_user = User.first
    current_user.position = "web_owner"
    expect(Tournament.can_be_created_by(current_user)).to eq(true)

    current_user = User.first
    current_user.position = "web_admin"
    expect(Tournament.can_be_created_by(current_user)).to eq(true)

    current_user = User.first
    current_user.position = "user"
    expect(Tournament.can_be_created_by(current_user)).to eq(false)
  end

  it "cannot be create with invalid max_user_count" do
    start_date = DateTime.now + 1.days
    tournament_time = Time.new(2000, 1, 1, 14, 00, 0)

    (1..40).each do |max_user_count|
      start_date = start_date + 10.days
      tournament_time = Time.new(2000, 1, 1, 14, 00, 0)

      tournament_hash = {
        title: "default_tournament", 
        rule_id: 1, 
        max_user_count: max_user_count,
        start_date: start_date,
        tournament_time: tournament_time,
        incentive_title: "super rookie2",
        incentive_gift: "nekarakube",
        target_match_score: 5,
        status: "pending"
      }
      
      tournament = Tournament.create(tournament_hash)

      if [8, 16, 32].include?(max_user_count)
        expect(tournament.persisted?).to eq(true)
      else
        expect(tournament.persisted?).to eq(false)
      end
    end
  end
end
