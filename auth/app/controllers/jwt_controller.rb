# check Homework week2

class JwtController < ApplicationController
  def validate
    token = params[:token]
    result = ValidateJwtToken.call(token: token)
    if result.success?
      render json: { user_id: result.user_id }
    else
      head :not_authorised
    end
  end
end
