class UserController < ActionController::API
  skip_before_action :authenticate_user, only: %i[create]

  def create
    user = User.find_by(email: params[:email]) if params[:email].present?
    if user
      render json: { exists: true }
    else
      user = User.new(user_params)
      if user.save
        token = Knock::AuthToken.new(payload: { sub: user.id }).token
        response.headers['Authorization'] = token
        render json: user
      else
        render json: user.errors.full_messages
      end
    end
  end
end
