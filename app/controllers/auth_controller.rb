class AuthController < ApplicationController
  # POST /login
  def login
    user = User.find_by(email: login_params[:email].downcase)
    if user&.authenticate(login_params[:password])
      token = generate_token(user.id)
      render json: { token: token, user: { id: user.id, email: user.email, name: user.name } }, status: :ok
    else
      render json: { errors: ['Invalid email or password'] }, status: :unauthorized
    end
  end

  private

  def login_params
    params.require(:auth).permit(:email, :password)
  end

  def generate_token(user_id)
    exp = JWT_EXPIRY_HOURS.hours.from_now.to_i
    payload = { user_id: user_id, exp: exp }
    JWT.encode(payload, JWT_SECRET, 'HS256')
  end
end
