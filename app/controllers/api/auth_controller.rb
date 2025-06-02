class Api::AuthController < Api::ApplicationController
  include ExceptionHandler
  
  before_action :authenticate_request, only: [:me, :update_profile]
  
  def signup
    user = User.new(user_params.merge(role: 'customer'))
    
    if user.save
      token = JwtService.encode(user_id: user.id)
      
      render json: AuthResponseSerializer.new(
        message: 'Account created successfully',
        token: token,
        user: user
      ).as_json, status: :created
    else
      render json: ErrorSerializer.new(
        message: 'Account could not be created',
        errors: user.errors.full_messages
      ).as_json, status: :unprocessable_entity
    end
  end
  
  def login
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)
      
      render json: AuthResponseSerializer.new(
        message: 'Login successful',
        token: token,
        user: user
      ).as_json, status: :ok
    else
      render json: ErrorSerializer.new(
        message: 'Invalid credentials'
      ).as_json, status: :unauthorized
    end
  end
  
  def me
    render json: UserSerializer.new(current_user).as_json, status: :ok
  end
  
  def update_profile
    if current_user.update(profile_params)
      render json: UserSerializer.new(current_user).as_json, status: :ok
    else
      render json: ErrorSerializer.new(
        message: 'Profile could not be updated',
        errors: current_user.errors.full_messages
      ).as_json, status: :unprocessable_entity
    end
  end
  
  private
  
  def authenticate_request
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
  end
  
  attr_reader :current_user
  
  def user_params
    params.permit(:name, :email, :phone, :password)
  end
  
  def profile_params
    if current_user.admin?
      params.permit(:name, :email, :phone, :firm_name)
    else
      params.permit(:name, :email, :phone)
    end
  end
end