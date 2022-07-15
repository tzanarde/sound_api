class ApplicationController < ActionController::API
  def authenticate
    if !User.authenticate(request.headers['email'], request.headers['password']).count.positive?
      render json: { errors: ['user not logged in'] }, status: :unauthorized
    end
  end
end
