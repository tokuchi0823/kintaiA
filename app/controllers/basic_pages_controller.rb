class BasicPagesController < ApplicationController
  before_action :admin_user, only: [:basic]
  
  def basic
  end
end
