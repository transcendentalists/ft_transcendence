require 'rails_helper'
require 'helpers/war_helper'
require 'helpers/guild_helper'
require 'helpers/match_helper'

RSpec.describe WarJob, type: :job do
  include WarHelper
  include GuildHelper
  include MatchHelper

  it "war 매치에서 challenger가 승리하였다면, 승자만 20 war point 증가" do
    master_1 = create(:user)
    master_2 = create(:user)

    guild_1 = create_guild({owner: master_1, name: "testone", anagram: "@on", point: 1000})
    guild_2 = create_guild({owner: master_2, name: "testtwo", anagram: "@tw", point: 1500})

    # war에는 dual, ladder 타입의 매치가 포함됨.
    war = create_war({challenger: guild_1, enemy: guild_2, match_types: ["war, dual"]})

    war_match = create_match({eventable_id: war.id, left_user: master_1, right_user: master_2, match_type: "war"})

    challenger_status = war.reload.war_statuses.find_by_position("challenger")
    enemy_status = war.reload.war_statuses.find_by_position("enemy")

    before_challenger_point = challenger_status.point
    before_enemy_point = enemy_status.point

    let_challenger_win(war_match)

    after_challenger_point = before_challenger_point + 20
    after_enemy_point = before_enemy_point
    expect(challenger_status.reload.point).to eq(after_challenger_point)
    expect(enemy_status.reload.point).to eq(after_enemy_point)
  end

  it "dual 매치에서 challenger가 승리하였다면, 승자만 20 war point 증가" do
    master_1 = create(:user)
    master_2 = create(:user)

    guild_1 = create_guild({owner: master_1, name: "testone", anagram: "@on", point: 1000})
    guild_2 = create_guild({owner: master_2, name: "testtwo", anagram: "@tw", point: 1500})

    # war에는 dual, ladder 타입의 매치가 포함됨.
    war = create_war({challenger: guild_1, enemy: guild_2, match_types: ["war, dual"]})

    # 2. dual 매치에서 challenger가 승리하였다면, 승자만 20 war point 증가
    dual_match = create_match({eventable_id: war.id, left_user: master_1, right_user: master_2, match_type: "dual"})

    challenger_status = war.reload.war_statuses.find_by_position("challenger")
    enemy_status = war.reload.war_statuses.find_by_position("enemy")

    before_challenger_point = challenger_status.point
    before_enemy_point = enemy_status.point

    let_challenger_win(dual_match)

    after_challenger_point = before_challenger_point + 20
    after_enemy_point = before_enemy_point
    expect(challenger_status.reload.point).to eq(after_challenger_point)
    expect(enemy_status.reload.point).to eq(after_enemy_point)


  end

  it "ladder 매치에서 challenger가 승리하였다면, 양 쪽 다 포인트 변화없음." do
    master_1 = create(:user)
    master_2 = create(:user)

    guild_1 = create_guild({owner: master_1, name: "testone", anagram: "@on", point: 1000})
    guild_2 = create_guild({owner: master_2, name: "testtwo", anagram: "@tw", point: 1500})

    # war에는 dual, ladder 타입의 매치가 포함됨.
    war = create_war({challenger: guild_1, enemy: guild_2, match_types: ["war, dual"]})

    # 3. ladder 매치에서 challenger가 승리하였다면, 양 쪽 다 포인트 변화없음.
    ladder_match = create_match({eventable_id: war.id, left_user: master_1, right_user: master_2, match_type: "ladder"})

    challenger_status = war.reload.war_statuses.find_by_position("challenger")
    enemy_status = war.reload.war_statuses.find_by_position("enemy")

    before_challenger_point = challenger_status.point
    before_enemy_point = enemy_status.point

    let_challenger_win(ladder_match)

    after_challenger_point = before_challenger_point
    after_enemy_point = before_enemy_point
    expect(challenger_status.reload.point).to eq(after_challenger_point)
    expect(enemy_status.reload.point).to eq(after_enemy_point)


  end

  it "tournament 매치에서 challenger가 승리하였다면, 양 쪽 다 포인트 변화없음." do
    master_1 = create(:user)
    master_2 = create(:user)

    guild_1 = create_guild({owner: master_1, name: "testone", anagram: "@on", point: 1000})
    guild_2 = create_guild({owner: master_2, name: "testtwo", anagram: "@tw", point: 1500})

    # war에는 dual, ladder 타입의 매치가 포함됨.
    war = create_war({challenger: guild_1, enemy: guild_2, match_types: ["war, dual"]})

    # 4. tournament 매치에서 challenger가 승리하였다면, 양 쪽 다 포인트 변화없음.
    tournament_match = create_match({eventable_id: war.id, left_user: master_1, right_user: master_2, match_type: "tournament"})

    challenger_status = war.reload.war_statuses.find_by_position("challenger")
    enemy_status = war.reload.war_statuses.find_by_position("enemy")

    before_challenger_point = challenger_status.point
    before_enemy_point = enemy_status.point

    let_challenger_win(tournament_match)

    after_challenger_point = before_challenger_point
    after_enemy_point = before_enemy_point
    expect(challenger_status.reload.point).to eq(after_challenger_point)
    expect(enemy_status.reload.point).to eq(after_enemy_point)
  end
end
