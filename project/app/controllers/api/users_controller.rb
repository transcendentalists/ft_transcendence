class Api::UsersController < ApplicationController
  def index
    if params[:for] == "ladder_index"
      users = User.order(point: :desc).page(params[:page].to_i)
    else
      users = User.all
    end
    render :json => { users: users }
    # render :json => users
  end

  def create
    render plain: "post /api/users"
  end

  def show
    id = params[:id]
    if params[:for] == "profile"
      user = User.includes(:in_guild, :score_cards, :tournament_memberships).find(id)
      render :json => { user: user.profile }
    else
      user = User.includes(:in_guild).find(id)
      render :json => { user: user.to_simple }
      # render :json => user
  end

  def update
    render plain: "update"
  end

  def login
    if User.exists?(signin_params)
      user = User.find_by_name(signin_params[:name]).login
      create_session user.id
      ApplicationMailer::sendVerificationCode(user).deliver_now if user.two_factor_auth
      render :json => { me: user.to_simple }
    else
      render :json => { error: {
        'type': 'login failure', 'msg': "가입된 이름이 없거나 비밀번호가 맞지 않습니다."
        }
      }, :status => 401
    end
  end

  # 유저가 로그아웃 버튼을 클릭했을 때 id를 이용한 로그아웃 프로세스 처리
  def logout
    id = params[:id]
    if (User.exists?(id))
      User.find(id).logout
    end
    remove_session
    render body: nil, status: 204
  end

  def ban
    render plain: "You banned " + params[:id] + " user"
  end

  private
  def signin_params
    params.require(:user).permit(:name, :password)
  end

end
