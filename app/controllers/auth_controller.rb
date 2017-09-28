class AuthController < ActionController::API
  skip_before_action :authenticate_user, raise: false

  def sign_in
    user = User.find_by(email: params[:email]) if params[:email].present?
    if user && user.authenticate(params[:password])
      token = Knock::AuthToken.new(payload: { sub: user.id }).token
      response.headers['Authorization'] = token
      render json: user
    else
      render status: 401
    end
  end
end
