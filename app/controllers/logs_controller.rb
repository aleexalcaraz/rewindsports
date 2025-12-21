class LogsController < ApplicationController
  def index
    @errors = AppError.all
    puts "Errors loaded", @errors
  end
end
