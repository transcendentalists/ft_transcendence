require 'rails_helper'

RSpec.describe User, type: :model do
  params = {
    rule_id: 3,
    bet_point: 100,
    start_date: "2021-03-30",
    war_time: 15,
    max_no_reply_count: 5,
    include_ladder: true,
    include_tournament: false,
    target_match_score: 5,
    war_duration: 5,
    enemy_guild_id: 2,
    guild_id: 1,
  }

  # begin
  #   WarRequest.create_by(params)
  # rescue => e # invalid
  #   expect(false).to eq(false)
  # else # valid
  #   expect(true).to eq(true)
  # end
  
  # 1. user가 member 또는 officer인 상황
  # 2. 우리 길드가 전쟁 중인 상황
  # 3. 상대 길드가 전쟁 중인 상황
  # 4. 이미 상대 길드에 초대장이 가 있는 상황
  # 5. 

  # it "can be created by hash" do
  #   begin
  #     WarRequest.create_by!(params)
  #   rescue
  #     expect(false).to eq(true)
  #   else
  #     expect(true).to eq(true)
  #   end
  # end

  it "no exist challenger guild" do
    test_id = [1, 2]
    test_id.each do |i|
      begin
      # test_id = [0, 1, "abc", "10", nil]
        p i
        params[:guild_id] = i
        WarRequest.create_by!(params)
      rescue
        @ret = false
        # expect(false).to eq(true)
      else
        @ret = true
        # expect(true).to eq(true)
      end

      if (@ret)
        expect(true).to eq(true)
      else
        expect(false).to eq(true)
      end

    end
  end

  # it "no exist enemy guild" do
  #   test = [0, 1, "1", "2", nil]
  #   test.each do |t|
  #     params[:enemy_guild_id] = t
  #     begin
  #       WarRequest.create_by!(params)
  #     rescue
  #       expect(false).to eq(true)
  #     else
  #       expect(true).to eq(true)
  #     end
  #   end
  # end
  # it "challenger guild is in war" do
  #   params[:rule_id] = 100
  #   begin
  #     WarRequest.create_by!(params)
  #   rescue
  #     expect(false).to eq(true)
  #   else
  #     expect(true).to eq(true)
  #   end
  # end
  # it "lack guild point" do
  #   params[:rule_id] = 100
  #   begin
  #     WarRequest.create_by!(params)
  #   rescue
  #     expect(false).to eq(true)
  #   else
  #     expect(true).to eq(true)
  #   end
  # end

  
  # it "cannot be created with invalid rule_id" do
  #   params[:rule_id] = 100
  #   begin
  #     WarRequest.create_by!(params)
  #   rescue
  #     expect(false).to eq(true)
  #   else
  #     expect(true).to eq(true)
  #   end
  # end

  # it "cannot be created with invalid bet_point" do
  #   params[:bet_point] = "abcd"
  #   begin
  #     WarRequest.create_by!(params)
  #   rescue
  #     expect(false).to eq(true)
  #   else
  #     expect(true).to eq(true)
  #   end
  # end

  # it "cannot be created with invalid start_date" do
  #   params[:start_date] = "2021-03-03"
  #   begin
  #     WarRequest.create_by!(params)
  #   rescue
  #     expect(false).to eq(true)
  #   else
  #     expect(true).to eq(true)
  #   end
  # end

  # it "cannot be created with invalid end_date" do
  #   params[:war_duration] = 10
  #   begin
  #     WarRequest.create_by!(params)
  #   rescue
  #     expect(false).to eq(true)
  #   else
  #     expect(true).to eq(true)
  #   end
  # end

  # it "cannot be created with invalid max_no_reply_count" do
  #   params[:max_no_reply_count] = 100
  #   begin
  #     WarRequest.create_by!(params)
  #   rescue
  #     expect(false).to eq(true)
  #   else
  #     expect(true).to eq(true)
  #   end
  # end

  # it "cannot be created with invalid target_match_score" do
  #   params[:target_match_score] = "ab"
  #   begin
  #     WarRequest.create_by!(params)
  #   rescue
  #     expect(false).to eq(true)
  #   else
  #     expect(true).to eq(true)
  #   end
  # end
end
