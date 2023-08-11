class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  private

  def authenticate_user!
    head :unauthorized unless current_user.present?
  end

  def current_user
    jwt = request.headers['Authorization']
    Rails.logger.info("JWT: #{jwt}")
    CurrentUser.call(token: request.headers['Authorization']).user
  end
end
