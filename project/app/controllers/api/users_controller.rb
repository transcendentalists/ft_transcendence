class Api::UsersController < ApplicationController
  def index
    render plain: "/api/users#index"
  end

  def create
    render plain: "post /api/users"
  end

  def show
    render plain: "get /api/users/" + params[:id]
  end

  def update
    render plain: "update"
  end

  def login
    # :id 가 아닌 :username 처럼 하는 방법은 없는건가?
    render plain: params[:id] + " just login"
  end

  def logout
    # :id 가 아닌 :username 처럼 하는 방법은 없는건가?
    render plain: params[:id] + " just logout"
  end

  def ban
    render plain: "You banned " + params[:id] + " user"
  end

end