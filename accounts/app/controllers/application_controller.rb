class ApplicationController < ActionController::Base
  VALID_ROLES = %w[admin account_manager].freeze
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  private

  def authenticate_user!
    head :unauthorized unless VALID_ROLES.include?(current_user&.role)
  end

  def current_user
    jwt = request.headers['Authorization']
    Rails.logger.info("JWT: #{jwt}")
    CurrentUser.call(token: request.headers['Authorization']).user
  end
end
