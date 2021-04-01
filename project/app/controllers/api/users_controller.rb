require 'bcrypt'

class Api::UsersController < ApplicationController
  before_action :check_headers_and_find_current_user, only: [:destroy, :update, :logout]

  def index
    begin
      case params[:for]
      when "appearance"
        users = User.onlineUsersWithoutFriends(service_params)
      when "ladder_index"
        users = User.for_ladder_index(params[:page])
      else
        users = User.all
      end
      render :json => { users: users }
    rescue => e
      perror e
      render_error :NotFound
    end
  end

  def create
    begin
      name, email, password = signup_params.values_at(:name, :email, :password)
      user = User.create!(
        name: name,
        email: email,
        password: BCrypt::Password.create(password)
      )
      ServiceError.new unless user.offline?
      create_session user.id
      user.login
      render json: { user: user.to_simple }
    rescue => e
      perror e
      render_error(:Conflict, "파라미터 형식이 올바르지 않습니다.")
    end
  end

  def show
    begin
      user = User.includes(:in_guild, :scorecards, :tournament_memberships).find(params[:id])
      case params[:for]
      when "appearance"
        render :json => { user: user.for_appearance(user.status) }
      when "profile"
        render :json => { user: user.profile }
      else
        render :json => { user: user.to_simple }
      end
    rescue => e
      perror e
      render_error :NotFound
    end
  end

  def update
    begin
      if (current_user_is_admin_or_owner?)
        raise ServiceError.new(:BadRequest) unless params.has_key?(:position)
        user = User.find(params[:id])
        user.update_position!({by: @current_user, position: params[:position]})
      else
        user = User.find(params[:id])
        if params.has_key?(:file)
          update_avatar!
        else
          raise ServiceError.new(:BadRequest) unless params.has_key?(:user)
          user.update!(update_params)
        end
      end
      head :no_content, status: 204
    rescue ServiceError => e
      perror e
      render_error(e.type, e.message);
    rescue => e
      perror e
      render_error :Conflict
    end
  end

  def login
    begin
      user = User.find_by_name(params[:user]['name'])
      raise ServiceError.new(:NotFound) if user.nil?
      raise ServiceError.new(:Forbidden) if user.banned?
      raise ServiceError.new(:Unauthorized) unless user.valid_password?(params[:user]['password'])
      if user.two_factor_auth?
        send_verification_code user
      else
        user.login
        create_session user.id
      end
      render json: { current_user: user.to_simple }
    rescue ServiceError => e
      perror e
      render_error(e.type, e.message);
    rescue => e
      perror e
      render_error :Conflict
    end
  end

  # 유저가 로그아웃 버튼을 클릭했을 때 id를 이용한 로그아웃 프로세스 처리
  def logout
    @current_user.logout
    remove_session
    render body: nil, status: 204
  end

  def destroy
    return render_error(:Forbidden) unless current_user_is_admin_or_owner?
    begin
      user = User.find(params[:id])
      raise ServiceError.new(:Forbidden) unless user.can_be_service_banned_by?(@current_user)
      user.service_ban!
      head :no_content, status: 204
    rescue ServiceError => e
      perror e
      render_error(e.type, e.message);
    rescue => e
      perror e
      render_error(:Conflict, "유저 계정 제한에 실패했습니다.")
    end
  end

  private

  def send_verification_code(user)
    verification_code = rand(100000..999999).to_s
    ActionMailer::Base.mail(to: user.email,
    subject: "[Transcendence] 2차 인증 메일입니다.",
    body: "인증번호는 [#{verification_code}] 입니다.",
    from: "transcendencet@gmail.com",
    content_type: "text/html").deliver_now
    user.update!(verification_code: verification_code)
  end

  def signup_params
    params.require(:user).permit(:name, :email, :password)
  end

  def signin_params
    params.require(:user).permit(:name)
  end

  def update_params
    params.require(:user).permit(:id, :name, :two_factor_auth)
  end

  def service_params
    params.permit(:id, :name, :for, :user_id, status: [])
  end

  def update_avatar!
    @current_user.avatar.purge if @current_user.avatar.attached?
    @current_user.avatar.attach(params[:file])
    @current_user.image_url = url_for(@current_user.avatar)
    @current_user.save!
  end
end
