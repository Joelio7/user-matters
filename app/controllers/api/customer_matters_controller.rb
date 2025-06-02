class Api::CustomerMattersController < Api::ApplicationController
  include ExceptionHandler

  before_action :authenticate_request
  before_action :ensure_admin!
  before_action :set_customer
  before_action :set_matter, only: [ :show, :update, :destroy ]

  def index
    matters = @customer.matters.includes(:user)
    render json: matters.map { |matter| MatterSerializer.new(matter).as_json }
  end

  def create
    matter = @customer.matters.build(matter_params)

    if matter.save
      render json: MatterSerializer.new(matter).as_json, status: :created
    else
      render json: ErrorSerializer.new(
        message: "Matter could not be created",
        errors: matter.errors.full_messages
      ).as_json, status: :unprocessable_entity
    end
  end

  def show
    render json: MatterSerializer.new(@matter).as_json
  end

  def update
    if @matter.update(matter_params)
      render json: MatterSerializer.new(@matter).as_json
    else
      render json: ErrorSerializer.new(
        message: "Matter could not be updated",
        errors: @matter.errors.full_messages
      ).as_json, status: :unprocessable_entity
    end
  end

  def destroy
    @matter.destroy
    head :no_content
  end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
  end

  attr_reader :current_user

  def ensure_admin!
    unless current_user&.admin?
      render json: ErrorSerializer.new(
        message: "Admin access required"
      ).as_json, status: :forbidden
    end
  end

  def set_customer
    @customer = User.customer.find(params[:customer_id])
  rescue ActiveRecord::RecordNotFound
    render json: ErrorSerializer.new(message: "Customer not found").as_json, status: :not_found
  end

  def set_matter
    @matter = @customer.matters.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: ErrorSerializer.new(message: "Matter not found for this customer").as_json, status: :not_found
  end

  def matter_params
    params.permit(:title, :description, :state, :due_date)
  end
end
