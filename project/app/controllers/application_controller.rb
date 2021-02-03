class ApplicationController < ActionController::Base
  def create_session id
    cookies.encrypted[:service_id] = id
  end

  def remove_session
    cookies.encrypted[:service_id] = 0
  end

  def is_current_user(id)
    cokkies.encrypted[:service_id] == id
  end
end
