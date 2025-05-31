class Api::MattersController < Api::ApplicationController
  include ExceptionHandler
  
  before_action :authenticate_request
  before_action :set_matter, only: [:show, :update, :destroy]
  
  def index
    authorize Matter
    matters = policy_scope(Matter).includes(:user)
    render json: matters.map { |matter| MatterSerializer.new(matter).as_json }
  end
  
  def create
    authorize Matter
    matter = current_user.matters.build(matter_params)
    
    if matter.save
      render json: MatterSerializer.new(matter).as_json, status: :created
    else
      render json: ErrorSerializer.new(
        message: 'Matter could not be created',
        errors: matter.errors.full_messages
      ).as_json, status: :unprocessable_entity
    end
  end
  
  def show
    authorize @matter
    render json: MatterSerializer.new(@matter).as_json
  end
  
  def update
    authorize @matter
    
    if @matter.update(matter_params)
      render json: MatterSerializer.new(@matter).as_json
    else
      render json: ErrorSerializer.new(
        message: 'Matter could not be updated',
        errors: @matter.errors.full_messages
      ).as_json, status: :unprocessable_entity
    end
  end
  
  def destroy
    authorize @matter
    @matter.destroy
    head :no_content
  end
  
  private
  
  def authenticate_request
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
  end
  
  attr_reader :current_user
  
  def set_matter
    @matter = Matter.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: ErrorSerializer.new(message: 'Matter not found').as_json, status: :not_found
  end
  
  def matter_params
    params.permit(:title, :description, :state, :due_date)
  end
end