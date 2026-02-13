class LogsController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]
  protect_from_forgery with: :null_session
  before_action :authenticate, only: :create, if: -> { request.content_type == 'application/json' }

  def index
    @page = (params[:page] || 1).to_i
    @per_page = 20
    @errors = AppError.order(created_at: :desc).offset((@page - 1) * @per_page).limit(@per_page)
    @total_pages = (AppError.count / @per_page.to_f).ceil
  end

  def create
    @log = AppError.new(log_params)
    if @log.save
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  def destroy
    @log = AppError.find(params[:id])
    @log.destroy
    redirect_to logs_path, notice: "Log deleted successfully."
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
