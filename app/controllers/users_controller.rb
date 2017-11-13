class UsersController < ActionController::API
  skip_before_action :authenticate_user, raise: false, only: %i[create]

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

  def update
    user = User.find(params[:id])
    if user.update_attributes(user_params)
      render json: user
    else
      render json: user.errors.full_messages
    end
  end

  def show
    user = User.find(params[:id])
    render json: user
  end

  def avatar
    data = ActiveSupport::Base64.encode64[:data]
    image = Cloudinary::Uploader.upload(data)

    render json: { status: 'ok' }
  end

  private

  def user_params
    params.permit(:id, :email, :username, :password)
  end
end
