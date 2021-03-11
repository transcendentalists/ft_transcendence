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

  def render_error(type, msg = nil)
    error_hash = {
      Unauthorized: ["요청을 수행할 권한이 없습니다.", 401],
      InternalServerError: ["서버 내부에 문제가 있습니다." ,500],
    }

    if msg.nil?
      msg =  error_hash.has_key?(type) ? error_hash[type][0] : "잘못된 요청입니다."
    end

    status_code = error_hash.has_key?(type) ? error_hash[type][1] : 400

    return render :json => { error: {
      'type': type, 'msg': msg, 'code': status_code
      }
    }, :status => status_code
  end

  def check_headers_and_find_current_user
    return render_error :Unauthorized if !request.headers['HTTP_CURRENT_USER']
    @current_user = User.find_by_id(request.headers['HTTP_CURRENT_USER'])
    return render_error :Unauthorized if @current_user.nil?
  end

  def current_user_is_admin_or_owner?
    admin_id = request.headers['HTTP_ADMIN']
    !admin_id.nil? && ["web_admin", "web_owner"].include?(User.find_by_id(admin_id)&.position)
  end
end
