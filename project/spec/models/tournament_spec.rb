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

  # it "can be created by web_owner or web_admin" do
  #   current_user = User.first
  #   current_user.position = "web_owner"
  #   expect(Tournament.can_be_created_by(current_user)).to eq(true)

  #   current_user = User.first
  #   current_user.position = "web_admin"
  #   expect(Tournament.can_be_created_by(current_user)).to eq(true)

  #   current_user = User.first
  #   current_user.position = "user"
  #   expect(Tournament.can_be_created_by(current_user)).to eq(false)
  # end

  # it "cannot be create with invalid max_user_count" do
  #   start_date = DateTime.now + 1.days
  #   tournament_time = Time.new(2000, 1, 1, 14, 00, 0)

  #   (1..40).each do |max_user_count|
  #     start_date = start_date + 10.days
  #     tournament_time = Time.new(2000, 1, 1, 14, 00, 0)

  #     tournament_hash = {
  #       title: "default_tournament", 
  #       rule_id: 1, 
  #       max_user_count: max_user_count,
  #       start_date: start_date,
  #       tournament_time: tournament_time,
  #       incentive_title: "super rookie2",
  #       incentive_gift: "nekarakube",
  #       target_match_score: 5,
  #       status: "pending"
  #     }
      
  #     tournament = Tournament.create(tournament_hash)

  #     if [8, 16, 32].include?(max_user_count)
  #       expect(tournament.persisted?).to eq(true)
  #     else
  #       expect(tournament.persisted?).to eq(false)
  #     end
  #   end

  # it "cannot be create with invalid word length" do
  #   start_date = DateTime.now + 1.days
  #   tournament_time = Time.new(2000, 1, 1, 14, 00, 0)
  #   title = ""

  #   (1..25).each do |n|
  #     start_date = start_date + 10.days

  #     tournament_hash = {
  #       title: title,
  #       rule_id: 1, 
  #       max_user_count: 32,
  #       start_date: start_date,
  #       tournament_time: tournament_time,
  #       incentive_title: "super rookie2",
  #       incentive_gift: "nekarakube",
  #       target_match_score: 5,
  #       status: "pending"
  #     }
      
  #     tournament = Tournament.create(tournament_hash)

  #     title = title + "t"
  #     if n == 1
  #       expect(tournament.persisted?).to eq(false)
  #     elsif n <= 21
  #       expect(tournament.persisted?).to eq(true)
  #     else
  #       expect(tournament.persisted?).to eq(false)
  #     end
  #   end
  # end


  # it "cannot be create with invalid incentive_title length" do
  #   start_date = DateTime.now + 1.days
  #   tournament_time = Time.new(2000, 1, 1, 14, 00, 0)
  #   incentive_title = "i"

  #   (1..25).each do |n|
  #     start_date = start_date + 10.days

  #     tournament_hash = {
  #       title: "title",
  #       rule_id: 1, 
  #       max_user_count: 32,
  #       start_date: start_date,
  #       tournament_time: tournament_time,
  #       incentive_title: incentive_title,
  #       incentive_gift: "nekarakube",
  #       target_match_score: 5,
  #       status: "pending"
  #     }
      
  #     tournament = Tournament.create(tournament_hash)

  #     if n <= 20
  #       expect(tournament.persisted?).to eq(true)
  #     else
  #       expect(tournament.persisted?).to eq(false)
  #     end

  #     incentive_title = incentive_title + "i"
  #   end
  # end


  # it "cannot be created with invalid incentive_gift length" do
  #   start_date = DateTime.now + 1.days
  #   tournament_time = Time.new(2000, 1, 1, 14, 00, 0)
  #   incentive_gift = nil

  #   (1..25).each do |n|
  #     start_date = start_date + 10.days

  #     tournament_hash = {
  #       title: "title",
  #       rule_id: 1, 
  #       max_user_count: 32,
  #       start_date: start_date,
  #       tournament_time: tournament_time,
  #       incentive_title: "super rookie",
  #       incentive_gift: incentive_gift,
  #       target_match_score: 5,
  #       status: "pending"
  #     }
      
  #     tournament = Tournament.create(tournament_hash)

  #     if n <= 21
  #       expect(tournament.persisted?).to eq(true)
  #     else
  #       expect(tournament.persisted?).to eq(false)
  #     end

  #     incentive_gift = "" if incentive_gift.nil?
  #     incentive_gift = incentive_gift + "i"
  #   end
  # end

  it "cannot be created with invalid start_date" do
    start_date = DateTime.now - 1.days
    tournament_time = Time.zone.now.change({hour: 14})
    incentive_gift = nil

    (1..3).each do |n|
      tournament_hash = {
        title: "title",
        rule_id: 1, 
        max_user_count: 32,
        start_date: start_date.strftime("%Y-%m-%d"),
        tournament_time: tournament_time,
        incentive_title: "super rookie",
        incentive_gift: incentive_gift,
        target_match_score: 5,
        status: "pending"
      }
      
      tournament = Tournament.new(tournament_hash)

      if n <= 2
        expect(tournament.valid?).to eq(false)
      else
        expect(tournament.valid?).to eq(true)
      end

      start_date += 1.days
    end
  end


  it "cannot be created with invalid tournament_time" do
    start_date = DateTime.now + 1.days
    incentive_gift = nil

    (1..23).each do |n|
      tournament_time = Time.zone.now.change({hour: n})
      tournament_hash = {
        title: "title",
        rule_id: 1, 
        max_user_count: 32,
        start_date: start_date.strftime("%Y-%m-%d"),
        tournament_time: tournament_time,
        incentive_title: "super rookie",
        incentive_gift: incentive_gift,
        target_match_score: 5,
        status: "pending"
      }
      
      tournament = Tournament.new(tournament_hash)

      if n < 9 || n > 22
        expect(tournament.valid?).to eq(false)
      else
        expect(tournament.valid?).to eq(true)
      end

      start_date += 1.days
    end
  end
end
