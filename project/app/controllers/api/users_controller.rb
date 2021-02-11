require 'bcrypt'

class Api::UsersController < ApplicationController
  def index
    if params[:for] == 'appearance'
      users = User.onlineUsersWithoutFriends(service_params)
    elsif params[:for] == "ladder_index"
      users = User.for_ladder_index(params[:page])
    else
      users = User.all
    end
    render :json => { users: users }
  end

  def create
    param = signup_params
    if param.values.any?("") || User.exists?(name: param[:name]) || User.exists?(email: param[:email])
      render :json => { error: {
        'type': 'signup failure', 'msg': "형식이 올바르지 않거나 고유하지 않은 값이 있습니다."
        }
      }, :status => 401
    else
      user = User.create(
        name: param[:name], 
        email: param[:email], 
        password: BCrypt::Password.create(params[:password])
      )
      create_session user.id
      user.update_status("online")
      render :json => { user: user.to_simple }
    end
  end

  def show
    id = params[:id]
    if params[:for] == "profile"
      user = User.includes(:in_guild, :scorecards, :tournament_memberships).find(id)
      render :json => { user: user.profile }
    else
      user = User.includes(:in_guild).find(id)
      render :json => { user: user.to_simple }
    end
  end

  def update
    render plain: 'update'
  end

  def login
    user = User.find_by_name(params[:user][:name])
    if user
      if BCrypt::Password.new(user.password) == params[:user][:password]
        if user.two_factor_auth
          verification_code = rand(100000..999999).to_s
          user.update(verification_code: verification_code)
          ActionMailer::Base.mail(to: user.email,
            subject: "[Transcendence] 2차 인증 메일입니다.",
            body: "인증번호는 [#{verification_code}] 입니다.",
            from: "valhalla.host@gmail.com",
            content_type: "text/html").deliver_now 
        else
          user.login
          create_session user.id 
        end
        render :json => { current_user: user.to_simple }
      else
        render json: { error: {
          'type': 'login failure', 'msg': '비밀번호가 맞지 않습니다.'
        } }, status: 401
      end
    else
      render json: { error: {
        'type': 'login failure', 'msg': '가입된 이름이 없습니다.'
      } }, status: 401
    end 
  end

  # 유저가 로그아웃 버튼을 클릭했을 때 id를 이용한 로그아웃 프로세스 처리
  def logout
    id = params[:id]
    User.find(id).logout if User.exists?(id)
    remove_session
    render body: nil, status: 204
  end

  def ban
    render plain: 'You banned ' + params[:id] + ' user'
  end

  private
  def signup_params
    params.require(:user).permit(:name, :email, :password)
  end

  def signin_params
    params.require(:user).permit(:name)
  end

  def service_params
    params.permit(:id, :name, :for, :user_id, status: [])
  end
end
