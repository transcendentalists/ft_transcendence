require "oauth2"

class SpaController < ApplicationController
  def ft_auth
    redirect_to "https://api.intra.42.fr/oauth/authorize?client_id=#{ENV['FT_CLIENT_ID']}&redirect_uri=http%3A%2F%2F127.0.0.1%3A3000%2Fauth%2F42%2Fcallback&response_type=code"
  end

  def ft_auth_callback
    return redirect_to action: "ft_auth" if params.key?(:error)
    redirect_to :controller => 'spa', :action => 'index'
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
    rescue => e
      perror e
      render_error :Unauthorized, "인증번호가 맞지 않습니다."
    end
  end

  def index
    return redirect_to action: "ft_auth" if params.key?(:error)
    uid = ENV['FT_CLIENT_ID']
    client_secret = ENV['FT_SECRET']
    client = OAuth2::Client.new(uid, client_secret, site: "https://api.intra.42.fr")
    token = client.client_credentials.get_token
    begin
      token.post('/oauth/token', {body: {
        grant_type: "authorization_code",
        client_id: uid,
        client_secret: client_secret,
        code: params[:code],
        redirect_uri: "http://127.0.0.1:3000/auth/42/callback"
      }})
    rescue
      return redirect_to action: "ft_auth"
    end
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
