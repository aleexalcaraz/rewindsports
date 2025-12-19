class ApplicationController < ActionController::Base
  include Authentication
  helper_method :current_user
  allow_browser versions: :modern

  def current_user
    Current.user
  end
end
