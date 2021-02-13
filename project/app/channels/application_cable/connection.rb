module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    rescue_from StandardError, with: :report_error

    def connect
      self.current_user = find_verified_user
    end

    def disconnect
      self.current_user.logout
    end

    private

    def find_verified_user
      if User.exists?(cookies.encrypted[:service_id])
        verified_user = User.find(cookies.encrypted[:service_id])
      else
        reject_unauthorized_connection
      end
    end

    def report_error(e)
      p e.message
    end
  end
end
