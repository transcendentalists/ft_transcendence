class Api::WarRequestsController < ApplicationController
  def index
    render plain: params[:guild_id] + " guild's war requests index"
  end

  def create
    render plain: params[:guild_id] + " guild's war requests created"
  end

  def destroy
    render plain: params[:guild_id] + " guild destory " + params[:id] + " war request"
  end
end
