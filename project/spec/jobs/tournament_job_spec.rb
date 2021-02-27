require "rails_helper"
require "helpers/tournament_helper"

describe "tournament test" do
  include TournamentHelper

  it "최소인원보다 미달일 때 토너먼트 시작 실패" do
    users_count = 7
    create_tournament({ register: users_count })
    expect_all_memberships_count users_count
    start_tournament
    expect_status "canceled"
    expect_all_matches_count 0
    expect_memberships_count(users_count, {status: "canceled"})
  end

  it "최소인원일 때 토너먼트 시작 성공" do
    users_count = 8
    create_tournament({ register: users_count })
    expect_all_memberships_count users_count
    start_tournament
    expect_status "progress"
    expect_memberships_count(users_count, {status: "progress"})
  end

  it "최소인원은 넘지만 최대인원보다 작을 때 토너먼트 시작 성공" do
    users_count = 9
    create_tournament({ register: users_count})
    expect_all_memberships_count users_count
    start_tournament
    expect_status "progress"
    expect_memberships_count(users_count, {status: "progress"})
  end

  it "최소인원일 때 토너먼트 첫 날 매칭 성공" do
    create_tournament({ register: 8 })
    start_tournament
    expect_all_matches_count 4
    expect_all_scorecards_count 8
  end

  it "홀수일 때 토너먼트 첫 날 매칭 성공" do
    users_count = 13
    create_tournament({ register: users_count })
    start_tournament
    expect_all_matches_count 6
    expect_all_scorecards_count 12
  end

  it "8배수 인원이 경기에 빠짐없이 참여할 때의 토너먼트 운영" do
    users_count = 8
    create_tournament({ register: users_count })
    simulate_tournament({ complete_ratio: [1.0] })
    
    expect_all_matches_count 7
    expect_all_scorecards_count 14
    expect_winner_get_title true
    expect_status "completed"

    expect_matches_count(7, {status: "completed"})
    expect_scorecards_count(7, {result: "win"})
    expect_scorecards_count(7, {result: "lose"})
    expect_memberships_count(8, {status: "completed"})
    expect_memberships_count(1, {result: "gold"})
    expect_memberships_count(1, {result: "silver"})
    expect_memberships_count(2, {result: "bronze"})
  end

end
