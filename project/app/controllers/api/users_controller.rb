class Api::UsersController < ApplicationController
  def index
    if params[:for] == "ladder_index"
      users = User.for_ladder_index(params[:page])
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
      user = User.includes(:in_guild, :scorecards, :tournament_memberships).find(id)
      render :json => { user: user.profile }
    else
      user = User.includes(:in_guild).find(id)
      render :json => { user: user.to_simple }
      # render :json => user
    end
  end

  def update
    if (params[:user].nil?)
      return render_error("upload fail", "user key가 없습니다.", 400);
    end
    params[:user] = JSON.parse(params[:user]) if params.key?("has_file")
    if (!User.exists?(params[:id]))
      return render_error("upload fail", "해당 id를 가진 user가 없습니다.", 400);
    end
    user = User.find(params[:id])

    if not params[:user]['two_factor_auth'].nil?
      user.update(update_params)
    elsif not params[:file].nil?
      user.avatar.purge if user.avatar.attached?
      user.avatar.attach(params[:file])
      user.image_url = url_for(user.avatar)
      user.save
    end
    head :no_content, status: 204
  end

  def login
    if User.exists?(signin_params)
      user = User.find_by_name(signin_params[:name]).login
      create_session user.id
      ApplicationMailer::sendVerificationCode(user).deliver_now if user.two_factor_auth
      render :json => { current_user: user.to_simple }
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

  def update_params
    params.require(:user).permit(:id, :image, :two_factor_auth)
  end

  def render_error(type, msg, status_code)
    return render :json => { error: {
      'type': type, 'msg': msg
      }
    }, :status => status_code
  end

end
