module WarHelper

  def create_war(options = {challenger: challenger, enemy: enemy,
                match_types: ["war", "dual"]})
    request = create_war_request(options[:match_types])
    challenger = options[:challenger]
    enemy = options[:enemy]

    challenger_war_status = create(:war_status,
                        guild_id: challenger.id,
                        war_request_id: request.id,
                        position: "challenger")

    enemy_war_status = create(:war_status,
                        guild_id: enemy.id,
                        war_request_id: request.id,
                        position: "enemy")
    war = create(:war, war_request_id: request.id)
  end

  def create_war_request(match_types = ["war", "dual"])
    start_date = Time.zone.yesterday.midnight
    end_date = Time.zone.now + 3.days
    war_time = Time.zone.now
    include_ladder = match_types.include?("ladder") ? true : false
    include_tournament = match_types.include?("tournament") ? true : false
    request = WarRequest.new({rule_id: 1,
                    bet_point: 100,
                    start_date: start_date,
                    end_date: end_date,
                    war_time: war_time,
                    max_no_reply_count: 3,
                    include_ladder: include_ladder,
                    include_tournament: include_tournament,
                    target_match_score: 3,
                    status: "accepted"})
    request.save(validate: false)
    request
  end

end
