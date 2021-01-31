class SpaController < ApplicationController
  def index
  end

  def test
    cookies.encrypted[:test] = 5
    render :json => { 
      'result': "success, eunhyul! ",
      'cookie': cookies.encrypted[:service_id_is]
    }
  end
end
