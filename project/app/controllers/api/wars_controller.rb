class Api::WarsController < ApplicationController
  def index
    if params[:for] == "index"
      war = Guild.find_by_id(params[:guild_id])&.wars.where.not(status: "completed").first
      return render_error("Not Found", "요청하신 전쟁 정보가 없습니다.", 404) if war.nil?
      index_data = war.index_data(params[:guild_id])
      return render_error("Not Found", "잘못된 요청입니다.", 400) if index_data.nil?
      render json: index_data
    elsif params[:guild_id]
      return render_error("Not Found", "길드가 없습니다.", 404) unless Guild.exists?(params[:guild_id])
      war_history_list = Guild.find_by_id(params[:guild_id]).wars.for_war_history(params[:guild_id])
      render json: { wars: war_history_list }
    else
      render plain: "This is war " + params[:war_id] + "'s matches"
    end
  end
end
