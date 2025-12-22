class LogsController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]
  protect_from_forgery with: :null_session
  before_action :authenticate, only: :create, if: -> { request.content_type == 'application/json' }

  def index
    @errors = AppError.all
  end

  def create
    @log = AppError.new(log_params)
    if @log.save
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  private

  def log_params
    params.require(:log).permit(:description, :source, :number, :is_error)
  end

  def authenticate
    authenticate_user_with_token || handle_bad_authentication
  end

  def authenticate_user_with_token
    authenticate_with_http_token do |token, options|
      @user ||= User.find_by(api_key: token)
    end
  end

  def handle_bad_authentication
    render json: { message: "Bad credentials" }, status: :unauthorized
  end
end
