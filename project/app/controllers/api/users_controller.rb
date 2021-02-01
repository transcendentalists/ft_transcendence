class Api::UsersController < ApplicationController
  def index
    users = User.all
    render :json => { users: users }
    # render :json => users
  end

  def create
    render plain: "post /api/users"
  end

  def show
    user = User.includes(:in_guild).find(params[:id])
    render :json => { user: user.to_backbone_simple }
    # render :json => user
  end

  def update
    render plain: "update"
  end

  def login
    if User.exists?(signin_params)
      user = User.session_login(signin_params)
      cookies.encrypted[:service_id] = user.id
      if (user.two_factor_auth)
        verification_code = rand(100000..999999).to_s
        user.update(verification_code: verification_code)

        ActionMailer::Base.mail(to: user.email,
          subject: "[Transcendence] 2차 인증 메일입니다.",
          body: "인증번호는 [#{verification_code}] 입니다.",
          from: "valhalla.host@gmail.com",
          content_type: "text/html").deliver_now

      end
      render :json => { me: user.to_backbone_simple }
    else
      render :json => { error: {
        'type': 'login failure', 'msg': "가입된 이름이 없거나 비밀번호가 맞지 않습니다."
        }
      }, :status => 401
    end
  end

  def logout
    # :id 가 아닌 :username 처럼 하는 방법은 없는건가?

    User.session_logout(params[:id].to_i)
    cookies.encrypted[:service_id] = 0
    render body: nil, status: 204
    # head :no_content
  end

  def ban
    render plain: "You banned " + params[:id] + " user"
  end

  private
  def signin_params
    params.require(:user).permit(:name, :password)
  end

end
