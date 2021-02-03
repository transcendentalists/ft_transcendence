module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    rescue_from StandardError, with: :report_error

    def connect
      p 'connect'
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      p 'verified_user'
      p 'verified_user'
      p 'verified_user'
      p 'verified_user'
      p 'verified_user'
      p 'Debug 1'
      if User.exists?(cookies.encrypted[:service_id])
        p 'Debug 2'
        verified_user = User.find(cookies.encrypted[:service_id])
      else
        p 'Debug 4'
        reject_unauthorized_connection
      end
    end

    def report_error(e)
      p e.message
    end
  end
end
