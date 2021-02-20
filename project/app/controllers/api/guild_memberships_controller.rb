class Api::GuildMembershipsController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [ :create, :update, :destroy ]

  def index
    render plain: params[:guild_id] + ' guild membership index'
  end

  def create
    if @current_user.id != params[:user][:id]
      return render_error("권한 에러", "접근 권한이 없습니다.", 401)
    end

    if not Guild.exists?(params[:guild_id])
      return(
        render_error('길드 가입 실패', '해당 길드 또는 유저가 존재하지 않습니다.', 404)
      )
    end
    guild_membership =
      GuildMembership.create(
        user_id: params[:user][:id],
        guild_id: params[:guild_id],
        position: params[:position],
      )
    if not guild_membership.valid?
      return(
        render_error(
          '길드 가입 실패',
          '유효하지 않은 정보가 포함되어 있습니다.',
          404,
        )
      )
    end
    render json: { guildMembership: guild_membership.profile }
  end

  def update
    render plain: params[:guild_id] + ' guild membership update ' + params[:id]
  end

  def destroy
    membership = GuildMembership.find_by_id(params[:id])
    if membership.nil?
      return render_error("길드 탈퇴 실패", "해당 유저의 길드 정보가 존재하지 않습니다.", 401)
    end
    if @current_user.guild_membership.guild_id != membership.guild_id || (
      @current_user.id != membership.user_id &&
      @current_user.guild_membership.position == "member"
    )
      return render_error("권한 에러", "접근 권한이 없습니다.", 401)
    end
    membership.destroy
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
