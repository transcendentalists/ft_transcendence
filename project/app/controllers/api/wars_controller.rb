class Api::WarsController < ApplicationController
  def index
    if params[:for] == "index"
      war_id = Guild.find_by_id(params[:guild_id]).wars.where.not(status: "completed").first
      get_data(war_id)
    elsif params[:guild_id]
      return render_error("Not Found", "Guild가 없습니다.", 404) unless Guild.exists?(params[:guild_id])
      war_history_list = Guild.find_by_id(params[:guild_id]).wars.for_war_history(params[:guild_id])
      render json: { wars: war_history_list }
    else
      render plain: "This is war " + params[:war_id] + "'s matches"
    end
  end

  def get_data(war_id)
    war = War.find_by_id(war_id)
    request = war.request
    my_guild_status = request.war_statuses.current_guild_war_status(params[:guild_id])
    opponent_guild_status = request.war_statuses.opponent_guild_war_status(params[:guild_id])
    my_guild  = my_guild_status.guild
    opponent_guild = opponent_guild_status.guild
    # TODO: 아래 두 해쉬만드는 로직은 메서드로 뺴기
    status = {
      my_guild_point: my_guild_status.point,
      opponent_guild_point: opponent_guild_status.point,
      max_no_reply_count: request.max_no_reply_count,
      remained_no_reply_count: request.max_no_reply_count - my_guild_status.no_reply_count,
    }
    rules_of_war = {
      bet_point: request.bet_point,
      start_date: request.start_date.to_date,
      end_date: request.end_date.to_date,
      rule: request.rule.name,
      max_no_reply_count: request.max_no_reply_count,
      war_time: request.war_time.hour,
      include_tournament: request.include_tournament,
      include_ladder: request.include_ladder,
    }
    matches = my_guild.war_match_history
    keys = %w[guild status rules_of_war matches]
    values = [opponent_guild.profile, status, rules_of_war, matches]
    hash = Hash[keys.zip values]
    render json: hash
  end
end
