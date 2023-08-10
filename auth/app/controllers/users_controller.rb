class UsersController < ApplicationController
  def index
    users = User.all
    render json: users
  end

  def create
    result = Users::Create.call(params: user_params)
    if result.success?
      render json: user, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])
    result = Users::Update.call(user: user, params: user_params)
    if result.success?
      render json: user
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name, :role)
  end
end
