class Api::WarsController < ApplicationController
  def index
    render plain: params[:guild_id] + "'s war index"
  end
end
