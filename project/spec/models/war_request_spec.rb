require 'rails_helper'

RSpec.describe WarRequest, type: :model do
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

  Guild.all.each do |guild|
    it "Cannot create war-request which is in-war" do
      p = params.clone
      p[:guild_id] = guild.id
      expect{ WarRequest.create_by!(p) }.to raise_error if guild.in_war?
    end
  end

  Guild.all.each do |guild|
    it "Cannot create war-request which is enemy guild-in-war" do
      p = params.clone
      p[:enemy_guild_id] = guild.id
      expect{ WarRequest.create_by!(p) }.to raise_error if guild.in_war?
    end
  end

  Guild.all.each do |guild|
    it "Cannot create war-request with lack guild-point " do
      p = params.clone
      p[:guild_id] = guild.id
      expect{ WarRequest.create_by!(p) }.to raise_error if guild.point < p[:bet_point]
    end
  end

  [0, nil, "0", "asd", "aa"].each do |i|
    it "no exist challenger guild" do
      p = params.clone
      p[:enemy_guild_id] = i
      expect{ WarRequest.create_by!(p) }.to raise_error
    end
  end

  [2, 4, 7].each do |i|
    it "exist challenger guild" do
      p = params.clone
      p[:enemy_guild_id] = i
      expect{ WarRequest.create_by!(p) }.not_to raise_error
    end
  end

  [0, nil, "bcd", "xxffqxsaaa32"].each do |i|
    it "no exist enemy guild" do
      p = params.clone
      p[:enemy_guild_id] = i
      expect{ WarRequest.create_by!(p) }.to raise_error
    end
  end
  [3, 4, 5].each do |i|
    it "exist enemy guild" do
      p = params.clone
      p[:enemy_guild_id] = i
      expect{ WarRequest.create_by!(p) }.not_to raise_error
    end
  end

  [0, "1", 45, 51, "bbbb", nil].each do |t|
    it "cannot be created with invalid bet_point" do
      p = params.clone
      p[:bet_point] = t
      expect{ WarRequest.create_by!(p) }.to raise_error
    end
  end
  [100, 150, 500, 950, 1000].each do |t|
    it "can be created with invalid bet_point" do
      p = params.clone
      p[:bet_point] = t
      expect{ WarRequest.create_by!(p) }.not_to raise_error
    end
  end

  (1..7).each do |t|
    it "can be created with invalid rule_id" do
      p = params.clone
      p[:rule_id] = t
      expect{ WarRequest.create_by!(p) }.not_to raise_error
    end
  end
  [0, "asd", "Test", 1000, nil].each do |t|
    it "cannot be created with invalid rule_id" do
      p = params.clone
      p[:rule_id] = t
     expect{ WarRequest.create_by!(p) }.to raise_error
    end
  end

  (100..1000).step(50).each do |t|
      p = params.clone
    it "can be created with invalid bet_point" do
      p[:bet_point] = t
      expect{ WarRequest.create_by!(p) }.not_to raise_error
    end
  end
  [1, 10, 40, 51, "test", nil].each do |t|
    it "Cannot be created with invalid bet_point" do
      p = params.clone
      p[:bet_point] = t
      expect{ WarRequest.create_by!(p) }.to raise_error
    end
  end

  ["2021-03-07", "2021-03-08", "2021-05-03"].each do |t|
    it "Can be created with invalid start_date" do
      p = params.clone
      p[:start_date] = t
      expect{ WarRequest.create_by!(p) }.not_to raise_error
    end
  end
  [0, 20201001, "2021-ads02-04", "202adsa1-03-08", nil].each do |t|
    it "Cannot be created with invalid start_date" do
      p = params.clone
      p[:start_date] = t
      expect{ WarRequest.create_by!(p) }.to raise_error
    end
  end

  (3..10).each do |t|
    it "can be created with invalid max_no_reply_count" do
      p = params.clone
      p[:max_no_reply_count] = t
      expect{ WarRequest.create_by!(p) }.not_to raise_error
    end
  end
  [0, -1, 'abc', 1000, nil].each do |t|
    it "cannot be created with invalid max_no_reply_count" do
      p = params.clone
      p[:max_no_reply_count] = t
      expect{ WarRequest.create_by!(p) }.to raise_error
    end
  end

  [3, 5, 7, 10].each do |t|
    it "can be created with invalid target_match_score" do
      p = params.clone
      p[:target_match_score] = t
      expect{ WarRequest.create_by!(p) }.not_to raise_error
    end
  end
  [0, 1, -1, 'abc', nil].each do |t|
    it "cannot be created with invalid target_match_score" do
      p = params.clone
      p[:target_match_score] = t
      expect{ WarRequest.create_by!(p) }.to raise_error
    end
  end
end
