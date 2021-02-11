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
    render plain: 'post /api/users'
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
    if (params[:user].nil?)
      return render_error("upload fail", "API에 user 키가 없습니다.", 400);
    end
    params[:user] = JSON.parse(params[:user]) if params.key?("has_file")
    if !User.exists?(params[:id])
      return render_error("upload fail", "해당 id를 가진 user가 없습니다.", 400);
    end
    user = User.find(params[:id])

    if params.has_key?(:file)
      user.avatar.purge if user.avatar.attached?
      user.avatar.attach(params[:file])
      user.image_url = url_for(user.avatar)
      user.save
    elsif user.update(update_params) == false
      return render_error("parameter error", "유효하지 읺은 파라미터입니다.", 400);
    end
    head :no_content, status: 204
  end

  def login
    if User.exists?(signin_params)
      user = User.find_by_name(signin_params[:name]).login
      create_session user.id
      verification_code = rand(100000..999999).to_s
      user.update(verification_code: verification_code)
      ActionMailer::Base.mail(to: user.email,
        subject: "[Transcendence] 2차 인증 메일입니다.",
        body: "인증번호는 [#{verification_code}] 입니다.",
        from: "valhalla.host@gmail.com",
        content_type: "text/html").deliver_now if user.two_factor_auth

      render :json => { current_user: user.to_simple }
    else
      render json: { error: {
        'type': 'login failure', 'msg': '가입된 이름이 없거나 비밀번호가 맞지 않습니다.'
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

  def signin_params
    params.require(:user).permit(:name, :password)
  end

  def update_params
    params.require(:user).permit(:name, :image, :two_factor_auth)
  end

  def service_params
    params.permit(:id, :name, :for, :user_id, status: [])
  end
end
