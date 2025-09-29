class UsersController < ApplicationController
  # POST /signup
  def create
    user = User.new(user_params)
    user.email = user.email.downcase
    if user.save
      token = JWT.encode({ user_id: user.id, exp: JWT_EXPIRY_HOURS.hours.from_now.to_i }, JWT_SECRET, 'HS256')
      render json: { token: token, user: { id: user.id, email: user.email, name: user.name } }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
