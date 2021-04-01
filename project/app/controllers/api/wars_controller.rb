class Api::WarsController < ApplicationController
  # params[:for] == index -> war_index_view 응답
  # params[:guild_id] -> guild_detail_view 응답
  def index
    begin
      guild = Guild.find(params[:guild_id])
      if params[:for] == "index"
        war = guild.wars.where.not(status: "completed").first
        index_data = war.index_data!(params[:guild_id].to_i)
        render json: index_data
      else
        war_history_list = guild.wars.for_war_history!(params[:guild_id].to_i)
        render json: { wars: war_history_list }
      end
    rescue ActiveRecord::RecordNotFound => e
      perror e
      render_error :NotFound
    rescue => e
      perror e
      render_error :BadRequest
    end
  end
end
