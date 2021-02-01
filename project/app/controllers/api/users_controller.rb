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
    # :id 가 아닌 :username 처럼 하는 방법은 없는건가?
    if User.exists?(signin_params)
      data = User.session_login(signin_params)
      cookies.encrypted[:service_id] = data[:me][:id]
      render :json => data
    else
      render :json => { error: {
        'type': 'login failure', 'msg': "가입된 이름이 없거나 비밀번호가 맞지 않습니다."
        }
      }, :status => 401
    end
  end

  def logout
    # :id 가 아닌 :username 처럼 하는 방법은 없는건가?
    User.session_logout(params[:id])
    render :nothing => true, :status => 204
  end

  def ban
    render plain: "You banned " + params[:id] + " user"
  end

  private
  def signin_params
    params.require(:user).permit(:name, :password)
  end

end
