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
    # mg_client = Mailgun::Client.new 'your-api-key'

    # # Define your message parameters
    # message_params =  { from: 'bob@sending_domain.com',
    #                     to:   'sally@example.com',
    #                     subject: 'The Ruby SDK is awesome!',
    #                     text:    'It is really easy to send a message!'
    #                   }

    # # Send your message through the client
    # mg_client.send_message 'sending_domain.com', message_params

    # mg_client = Mailgun::Client.new 'f9725831530355a140a129a0d53c508c-77751bfc-09f115d6'
    # sanam_message_params =  { from: '42transcendalist@student.42seoul.kr',
    #                     to:   'simian114@gmail.com',
    #                     subject: 'The Ruby SDK is awesome!',
    #                     text:    'It is really easy to send a message!'
    #                   }
    # eunhkim_message_params =  { from: '42transcendalist@student.42seoul.kr',
    #                     to:   'valhalla.host@gmail.com',
    #                     subject: 'The Ruby SDK is awesome!',
    #                     text:    'It is really easy to send a message!'
    #                   }
    # yohlee_message_params =  { from: '42transcendalist@student.42seoul.kr',
    #                     to:   'yohan9612@naver.com',
    #                     subject: 'The Ruby SDK is awesome!',
    #                     text:    'It is really easy to send a message!'
    #                   }
    # mg_client.send_message 'transcendence.com', sanam_message_params
    # mg_client.send_message 'transcendence.com', eunhkim_message_params
    # mg_client.send_message 'transcendence.com', yohlee_message_params


    # :id 가 아닌 :username 처럼 하는 방법은 없는건가?
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
