class ApplicationController < ActionController::Base
  # TODO: 'protect... null_session' 코드는 CSRF token 인증 생략 위해 임시로 추가함.
  protect_from_forgery with: :null_session

  def create_session(id)
    cookies.encrypted[:service_id] = id
  end

  def remove_session
    cookies.encrypted[:service_id] = 0
  end

  def render_error(type, msg, status_code)
    return render :json => { error: {
      'type': type, 'msg': msg
      }
    }, :status => status_code
  end
end
