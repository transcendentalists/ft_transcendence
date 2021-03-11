class SpaController < ApplicationController
  def ft_auth
    # redirect_to "https://api.intra.42.fr/oauth/authorize?client_id=659fe291e447e5713d7c2fe384ce6f8c70a3ab8e9668f4d40c751d400a9ece50&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth%2F42%2Fcallback&response_type=code"
  end

  def mail_auth
    begin
      user = User.find(params[:user][:id])
      verification_code = params[:user][:verification_code]
      user.verification!(verification_code)
      raise ServiceError.new unless user.offline?
      create_session user.id
      user.login(verification: true)
      render json: { current_user: user.to_simple }
    rescue
      render_error :Unauthorized, "인증번호가 맞지 않습니다."
    end
  end

  def index
    redirect_to action: "ft_auth" if params.key?(:error)
  end

  # 브라우저에 이전 로그인 기록이 남아있고,
  # 해당 유저가 오프라인이 아닐 경우 강제 로그아웃을 진행하여
  # 계정을 보호하고 브라우저당 동시 접속 제한
  def destroy
    id = cookies.encrypted[:service_id]
    return unless User.exists?(id)
    remove_session
    head :no_content, status: 204
  end
end
