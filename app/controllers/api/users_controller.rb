class Api::UsersController < Api::ApplicationController
  include ExceptionHandler
  
  before_action :authenticate_request
  before_action :set_user, only: [:show, :update, :destroy]
  
  def index
    authorize User
    users = policy_scope(User)
    render json: users.map { |user| UserSerializer.new(user).as_json }
  end
  
  def create
    authorize User
    
    user = User.new(user_params.merge(role: 'customer'))
    
    if user.save
      render json: UserSerializer.new(user).as_json, status: :created
    else
      render json: ErrorSerializer.new(
        message: 'User could not be created',
        errors: user.errors.full_messages
      ).as_json, status: :unprocessable_entity
    end
  end
  
  def show
    authorize @user
    render json: UserSerializer.new(@user).as_json
  end
  
  def update
    authorize @user
    
    if @user.update(user_update_params)
      render json: UserSerializer.new(@user).as_json
    else
      render json: ErrorSerializer.new(
        message: 'User could not be updated',
        errors: @user.errors.full_messages
      ).as_json, status: :unprocessable_entity
    end
  end
  
  def destroy
    authorize @user
    @user.destroy
    head :no_content
  end
  
  private
  
  def authenticate_request
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
  end
  
  attr_reader :current_user
  
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: ErrorSerializer.new(message: 'User not found').as_json, status: :not_found
  end
  
  def user_params
    params.permit(:name, :email, :firm_name, :password)
  end
  
  def user_update_params
    params.permit(:name, :email, :firm_name)
  end
end