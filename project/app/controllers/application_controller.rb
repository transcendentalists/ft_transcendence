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
      'type': type, 'msg': msg, 'code': status_code
      }
    }, :status => status_code
  end

  def check_headers_and_find_current_user
    if !request.headers['HTTP_CURRENT_USER']
      return render_error("NOT VALID HEADERS", "필요한 요청 Header가 없습니다.", 400)
    end
    @current_user = User.find_by_id(request.headers['HTTP_CURRENT_USER'])
    if @current_user.nil?
      return render_error("NOT VALID HEADERS", "요청 Header의 값이 유효하지 않습니다.", 400)
    end
  end

  def current_user_is_admin_or_owner?
    admin_id = request.headers['HTTP_ADMIN']
    !admin_id.nil? && ["web_admin", "web_owner"].include?(User.find_by_id(admin_id)&.position)
  end
  
  def current_user_is_owner?
    admin_id = request.headers['HTTP_ADMIN']
    !admin_id.nil? && User.find_by_id(admin_id)&.position == "web_owner"
  end
end
