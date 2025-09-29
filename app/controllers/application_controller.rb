class ApplicationController < ActionController::API
  before_action :set_default_format

  private

  def set_default_format
    request.format = :json
  end

  # authorize_request will be used as a before_action in controllers that need auth
  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header.present?
    begin
      decoded = JWT.decode(header, JWT_SECRET, true, algorithm: 'HS256')
      payload = decoded.first
      @current_user = User.find(payload['user_id'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
      render json: { errors: 'Unauthorized' }, status: :unauthorized
    end
  end
end
