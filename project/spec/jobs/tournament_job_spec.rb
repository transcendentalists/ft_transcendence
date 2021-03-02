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

  # 8인부터 32인 케이스 모두 체크시 시간이 45초 정도 소요되므로 적절히 변경하여 사용
  it "경기에 빠짐없이 참여할 때의 토너먼트 운영" do
    (8..32).each do |users_count|
      create_tournament({ register: users_count })
      simulate_tournament({ complete_ratio: [1.0] })
      
      match_count = matches_count_if_all_completed_when(users_count)
      expect_all_matches_count matches_count
      expect_all_scorecards_count matches_count*2
      expect_winner_get_title true
      expect_status "completed"

      expect_matches_count(matches_count, {status: "completed"})
      expect_scorecards_count(matches_count, {result: "win"})
      expect_scorecards_count(matches_count, {result: "lose"})
      expect_memberships_count(users_count, {status: "completed"})
      expect_memberships_count(1, {result: "gold"})
      expect_memberships_count(1, {result: "silver"})

      bronze_count = bronze_count_if_all_match_completed_when(users_count)
      expect_memberships_count(bronze_count, {result: "bronze"})
    end
  end

  # 8인부터 32인 케이스 모두 체크시 시간이 27초 정도 소요되므로 적절히 변경하여 사용
  it "모두 불참할 때의 토너먼트 운영" do
    (8..32).each do |users_count|
      create_tournament({ register: users_count })
      simulate_tournament({ complete_ratio: [0] })
      
      matches_count = users_count / 2
      expect_all_matches_count matches_count
      expect_all_scorecards_count matches_count*2
      expect_winner_get_title false
      expect_status "completed"

      expect_matches_count(matches_count, {status: "canceled"})
      expect_scorecards_count(matches_count*2, {result: "canceled"})
      expect_memberships_count(users_count, {status: "completed"})
      expect_memberships_count(0, {result: "gold"})
      expect_memberships_count(0, {result: "silver"})
      expect_memberships_count(0, {result: "bronze"})
    end
  end

  # 8인부터 32인 케이스 모두 체크시 시간이 35초 정도 소요되므로 적절히 변경하여 사용
  it "엣지 케이스 with ratio" do
    print_to "edge-tournament-log"
    (32..32).each do |users_count|
      create_tournament({ register: users_count })
      simulate_tournament({ complete_ratio: [0.8, 0.7, 1.0] })
      
      expect_matches_count(all_matches_count, {status: ["canceled", "completed"]})
      expect_scorecards_count(all_scorecards_count, {result: ["canceled", "win", "lose"]})
      expect_memberships_count(users_count, {status: "completed"})

      expect_status "completed"
      expect_all_scorecards_count all_matches_count*2
      expect_normal_memberships_result_count
    end
    print_close
  end
  
end
