class Api::WarsController < ApplicationController
  def index
    if params[:for] == "index"
      war_id = Guild.find_by_id(params[:guild_id]).wars.where.not(status: "completed").first
      render json: get_war_index_data(war_id)
    elsif params[:guild_id]
      return render_error("Not Found", "Guild가 없습니다.", 404) unless Guild.exists?(params[:guild_id])
      war_history_list = Guild.find_by_id(params[:guild_id]).wars.for_war_history(params[:guild_id])
      render json: { wars: war_history_list }
    else
      render plain: "This is war " + params[:war_id] + "'s matches"
    end
  end

  private
  def get_war_index_data(war_id)
    war = War.find_by_id(war_id)
    request = war.request
    my_guild_status = request.war_statuses.find_by_guild_id(params[:guild_id])
    opponent_guild_status = my_guild_status.opponent_guild_war_status
    status = my_guild_status.for_war_status_view(my_guild_status.guild)
    rules_of_war = my_guild_status.request.rules_of_war
    matches = my_guild_status.guild.war_match_history
    keys = %w[guild status rules_of_war matches war]
    values = [opponent_guild_status.guild.profile, status, rules_of_war, matches, war]
    war_index_data = Hash[keys.zip values]
  end
end
