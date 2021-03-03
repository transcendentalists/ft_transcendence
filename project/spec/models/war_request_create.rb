require 'rails_helper'

RSpec.describe User, type: :model do
  war_request_hash = {
    rule_id: 3,
    bet_point: 1000, start_date: Date.tomorrow,
    end_date: Date.tomorrow + 5.days,
    war_time: Time.new(1, 1, 1, 20),
    max_no_reply_count: 5,
    include_ladder: true,
    include_tournament: false,
    target_match_score: 5,
  }

  it "can be created by hash" do
  params = war_request_hash.clone
  war_request = WarRequest.new(params)
  expect(war_request.valid?).to eq(true)
  
  end

  it "cannot be created with invalid rule_id" do
  params = war_request_hash.clone
  params[:rule_id] = 100
  war_request = WarRequest.create(params)
  expect(war_request.valid?).to eq(false)
  end

  it "cannot be created with invalid bet_point" do
  params = war_request_hash.clone
  params[:bet_point] = "abcd"
  war_request = WarRequest.new(params)
  expect(war_request.valid?).to eq(false)
  end

  it "cannot be created with invalid start_date" do
  params = war_request_hash.clone
  params[:start_date] = Date.new
  war_request = WarRequest.new(params)
  expect(war_request.valid?).to eq(false)
  end

  it "cannot be created with invalid end_date" do
  params = war_request_hash.clone
  params[:end_date] = Date.new
  war_request = WarRequest.new(params)
  expect(war_request.valid?).to eq(false)
  end

  it "cannot be created with invalid max_no_reply_count" do
  params = war_request_hash.clone
  params[:max_no_reply_count] = 100
  war_request = WarRequest.new(params)
  expect(war_request.valid?).to eq(false)
  end

  it "cannot be created with invalid target_match_score" do
  params = war_request_hash.clone
  params[:target_match_score] = "ab"
  war_request = WarRequest.new(params)
  expect(war_request.valid?).to eq(false)
  end

end
