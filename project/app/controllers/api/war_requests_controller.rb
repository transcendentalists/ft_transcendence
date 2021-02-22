class Api::WarRequestsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :update ]

  def index
    if params[:for] == "guild_index"
      render json: { war_requests: WarRequest.for_guild_index(params[:guild_id]) }
    else
      render plain: params[:guild_id] + " guild's war requests index"
    end
  end

  def create
    render plain: params[:guild_id] + " guild's war requests created"
  end

  def update
    if @current_user.in_guild.nil? ||
      @current_user.in_guild.id != params[:guild_id].to_i ||
      @current_user.guild_membership.position == "member" 
      return render_error("권한 에러", "접근 권한이 없습니다.", 401)
    end
    war_request = WarRequest.find_by_id(params[:id])
    if war_request.nil?
      render_error("전쟁 요청 검색 에러", "요청하신 전쟁 요청이 존재하지 않습니다.", 404)
    end
    war_request.update(status: params[:status]) if params[:status]
    head :no_content, status: 204
  end

  private
  def check_headers_and_find_current_user
    if !request.headers['HTTP_CURRENT_USER']
      return render_error("NOT VALID HEADERS", "필요한 요청 Header가 없습니다.", 400)
    end
    @current_user = User.find_by_id(request.headers['HTTP_CURRENT_USER'])
    if @current_user.nil?
      return render_error("NOT VALID HEADERS", "요청 Header의 값이 유효하지 않습니다.", 400)
    end
  end

end
