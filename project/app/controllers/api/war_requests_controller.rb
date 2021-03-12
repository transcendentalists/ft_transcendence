class Api::WarRequestsController < ApplicationController
  before_action :check_headers_and_find_current_user

  def index
    begin
      if params[:for] == "guild_index"
        render json: { war_requests: WarRequest.for_guild_index(params[:guild_id]) }
      else
        render_error :BadRequest
      end
    rescue ActiveRecord::RecordNotFound
      render_error :NotFound
    rescue
      render_error :Conflict
    end
  end

  def create
    begin
      params = create_params
      guild = Guild.find(params[:guild_id])
      unless WarRequest.can_be_created_by?({ current_user: @current_user, guild: guild })
        raise ServiceError.new(:Forbidden)
      end
      raise ServiceError.new if guild.already_request_to?(params[:enemy_guild_id])
      ActiveRecord::Base.transaction do
        war_request = WarRequest.create_by!(params)
      end
      render json: { war_request_id: war_request.id }
    rescue ActiveRecord::RecordNotFound
      render_error :NotFound
    rescue ActiveRecord::RecordInvalid
      key =  e.record.errors.attribute_names.first
      error_message = e.record.errors.messages[key].first
      render_error(:BadRequest, error_message) 
    rescue ServiceError => e
      render_error(e.type, e.message)
    rescue
      render_error :Conflict
    end
  end

  def update
    begin
      war_request = WarRequest.find(params[:id])
      raise ServiceError.new(:Forbidden) unless war_request.can_be_updated_by(@current_user)
      raise ServiceError.new(:BadRequest) unless war_request.status == "pending"

      ActiveRecord::Base.transaction do
        if params[:status] == "accepted"
          war_request.enemy.accept!(war_request)
        else
          war_request.update!(status: params[:status])
        end
      end
      head :no_content, status: 204
    rescue ActiveRecord::RecordNotFound
      render_error :NotFound
    rescue ActiveRecord::RecordInvalid
      key =  e.record.errors.attribute_names.first
      error_message = e.record.errors.messages[key].first
      render_error(:BadRequest, error_message) 
    rescue ServiceError => e
      render_error(e.type, e.message)
    rescue
      render_error :BadRequest
    end
  end

  private

  def create_params
    params.require(:guild_id)
    params.require(:enemy_guild_id)
    params.require(:war_duration)
    params.require(:war_request).permit(:rule_id, :bet_point, :start_date, :war_time, :max_no_reply_count, :include_ladder, :include_tournament, :target_match_score)
    params
  end
end
