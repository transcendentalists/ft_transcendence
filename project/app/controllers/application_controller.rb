class ApplicationController < ActionController::Base
  def create_session(id)
    cookies.encrypted[:service_id] = id
  end

  def remove_session
    user = User.find_by_id(cookies.encrypted[:service_id])
    cookies.encrypted[:service_id] = 0
    user.logout if !user.nil? && !user.offline?
    user.notification("same_browser_connection")
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
end
