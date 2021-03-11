class Api::WarsController < ApplicationController
  def index
    begin
      if params[:for] == "index"
        war = Guild.find(params[:guild_id])&.wars.where.not(status: "completed").first
        index_data = war.index_data!(params[:guild_id])
        render json: index_data
      elsif params[:guild_id]
        guild = Guild.find(params[:guild_id])
        war_history_list = guild.wars.for_war_history(params[:guild_id])
        render json: { wars: war_history_list }
      else
        render plain: "This is war " + params[:war_id] + "'s matches"
      end
    rescue ActiveRecord::RecordNotFound
      return render_error("Not Found", "요청하신 정보를 찾을 수 없습니다.", 404)
    rescue
      return render_error("Bad Request", "잘못된 요청입니다.", 400)
    end
  end
end
