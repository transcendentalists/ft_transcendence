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

    # match -> match, match가 대기중인지, 진행중인지 
    # eventable_id: 해당 war의 id 가 들어간다.
    # status: pending: 대기상태, progress: 게임상태
    war_match = war.matches.find_by_status(["pending", "progress"])

    # TODO: 변수 이름 수정
    is_my_guild = war_match.nil? ? false : war_match.scorecards.first.user.in_guild.id == params[:guild_id]
    # 시간초로 나옴
    wait_time = war_match&.status == "pending" ? Time.zone.now - war_match.updated_at : nil
    battle = {
              current_hour: Time.zone.now.hour,
              match: war_match,
              war_time: request.war_time.hour,
              is_my_guild: is_my_guild,
              wait_time: 250,
              # 남아있는 시간을 여기서 구한다음에 건네주는 방식 ok?
            }

    keys = %w[guild status rules_of_war matches war battle]
    values = [opponent_guild_status.guild.profile, status, rules_of_war, matches, war, battle]
    war_index_data = Hash[keys.zip values]
  end
end
