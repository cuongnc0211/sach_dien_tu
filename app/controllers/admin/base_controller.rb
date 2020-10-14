class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :authenticate_user!, :authen_admin

  private

  def authen_admin
    return if current_user.user?

    flash[:errors] = "You don't have authorize to access this content"
    redirect_to root_path
  end
end
