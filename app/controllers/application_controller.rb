class ApplicationController < ActionController::Base
  include Pundit

  def after_sign_in_path_for(resource)
    resource.is_admin ? admin_root_path : root_path
  end
end
