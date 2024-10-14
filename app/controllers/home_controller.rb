class HomeController < ApplicationController
  def index
    skip_authorization
  end

  def guide
    skip_authorization
  end
end
