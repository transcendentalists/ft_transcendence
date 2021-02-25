class Api::WarsController < ApplicationController
  def index
    if params[:guild_id]
      war_history_list = War.for_war_history(params[:guild_id])
      render :json => {
        wars: war_history_list
      }
    else
      render plain: "This is war " + params[:war_id] + "'s matches"
    end

  end
end
