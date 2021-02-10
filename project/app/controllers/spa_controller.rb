class SpaController < ApplicationController
  def ft_auth
    # redirect_to "https://api.intra.42.fr/oauth/authorize?client_id=659fe291e447e5713d7c2fe384ce6f8c70a3ab8e9668f4d40c751d400a9ece50&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth%2F42%2Fcallback&response_type=code"
  end

  def mail_auth
    user = User.find(params[:user][:id])
    if user.verification_code == params[:user][:verification_code]
      user.login(verification: true)
      render :json => { current_user: user.to_simple }
    else
      render :json => { error: {
        'type': 'login failure', 'msg': "인증번호가 맞지 않습니다."
        }
      }, :status => 401
    end
  end

  def index
    if params.key?(:error)
      redirect_to action: "ft_auth"
    end
  end

  def destroy
    id = cookies.encrypted[:service_id]
    return if not User.exists?(id)
    remove_session
    head :no_content
  end
end
