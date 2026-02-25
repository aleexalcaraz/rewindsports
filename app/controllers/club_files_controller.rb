class ClubFilesController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]
  protect_from_forgery with: :null_session
  before_action :authenticate, only: :create, if: -> { request.content_type&.include?("multipart") || request.content_type == "application/json" }

  def index
    @page = (params[:page] || 1).to_i
    @per_page = 20

    scope = ClubFile.includes(:club, file_attachment: :blob)
    @club_files = scope.order(created_at: :desc).offset((@page - 1) * @per_page).limit(@per_page)
    @total_pages = (scope.count / @per_page.to_f).ceil
  end

  def show
    @club_file = ClubFile.find(params[:id])
    send_data @club_file.file.download,
              filename: @club_file.file.filename.to_s,
              type: "text/plain",
              disposition: "inline"
  end

  def create
    @club_file = ClubFile.new(club_id: params[:club_id])
    @club_file.file.attach(params[:file]) if params[:file].present?
    if @club_file.save
      render json: { success: true }
    else
      render json: { success: false, errors: @club_file.errors.full_messages }
    end
  end

  def destroy
    @club_file = ClubFile.find(params[:id])
    @club_file.file.purge
    @club_file.destroy
    redirect_to club_files_path, notice: "File deleted successfully."
  end

  private

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
