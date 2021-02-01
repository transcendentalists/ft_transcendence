class SpaController < ApplicationController
  def ft_auth
    # redirect_to "https://api.intra.42.fr/oauth/authorize?client_id=659fe291e447e5713d7c2fe384ce6f8c70a3ab8e9668f4d40c751d400a9ece50&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth%2F42%2Fcallback&response_type=code"
    redirect_to "https://github.com/login/oauth/authorize?client_id=Iv1.51c3995ab7bfaf31"
  end

  # def github_auth
  #   redirect_to "https://github.com/login/oauth/authorize?client_id=Iv1.51c3995ab7bfaf31"
  # end

  def index
    if (params[:error] === "access_denied")
      redirect_to action: "ft_auth"
    end
  end

  def destroy
    User.session_logout(cookies.encrypted[:service_id])
    cookies.encrypted[:service_id] = 0
    head :no_content
  end
end
