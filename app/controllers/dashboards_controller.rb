class DashboardsController < ApplicationController
  before_action :require_admin
  helper_method :court_from_source

  BOT_VIDEO_DESCRIPTION = "BOT - Se genero un video".freeze
  PERIODS = %w[day week month year custom].freeze

  def index
    @club = current_user.club

    if @club
      scope = AppError
        .where(description: BOT_VIDEO_DESCRIPTION)
        .where("source LIKE ?", "%#{sanitize_sql_like(@club.name)}%")

      now = Time.current
      @ranges = {
        "day"   => now.beginning_of_day..now.end_of_day,
        "week"  => now.beginning_of_week..now.end_of_week,
        "month" => now.beginning_of_month..now.end_of_month,
        "year"  => now.beginning_of_year..now.end_of_year
      }

      @count_day   = scope.where(created_at: @ranges["day"]).count
      @count_week  = scope.where(created_at: @ranges["week"]).count
      @count_month = scope.where(created_at: @ranges["month"]).count
      @count_year  = scope.where(created_at: @ranges["year"]).count

      @period = PERIODS.include?(params[:period]) ? params[:period] : "day"
      @from   = params[:from].presence
      @to     = params[:to].presence

      @entries =
        if @period == "custom"
          if @from || @to
            custom_scope = scope
            if @from
              custom_scope = custom_scope.where("created_at >= ?", Time.zone.parse(@from).beginning_of_day)
            end
            if @to
              custom_scope = custom_scope.where("created_at <= ?", Time.zone.parse(@to).end_of_day)
            end
            custom_scope
          else
            scope.none
          end
        else
          scope.where(created_at: @ranges[@period])
        end

      @entries = @entries.order(created_at: :desc)
    end
  end

  private
    def require_admin
      unless current_user
        redirect_to root_path, alert: "You are not authorized to access this page."
      end
    end

    def sanitize_sql_like(string)
      ActiveRecord::Base.sanitize_sql_like(string)
    end

    # Extracts the court name (the path segment right after the club name).
    # e.g. "/app/storage/PuntoPadel/Cancha3/clips/..." => "Cancha3"
    def court_from_source(source)
      parts = source.to_s.split("/")
      idx = parts.index(@club.name)
      idx ? parts[idx + 1] : nil
    end
end
