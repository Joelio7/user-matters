class Api::CustomersController < Api::ApplicationController
  include ExceptionHandler

  before_action :authenticate_request
  before_action :ensure_admin!
  before_action :set_customer, only: [ :show, :update, :destroy ]

  def index
    customers = User.customer.all
    render json: customers.map { |customer| CustomerSerializer.new(customer).as_json }
  end

  def create
    customer = User.new(customer_params.merge(role: "customer"))

    if customer.save
      render json: CustomerSerializer.new(customer).as_json, status: :created
    else
      render json: ErrorSerializer.new(
        message: "Customer could not be created",
        errors: customer.errors.full_messages
      ).as_json, status: :unprocessable_entity
    end
  end

  def show
    render json: CustomerSerializer.new(@customer).as_json
  end

  def update
    if @customer.update(customer_update_params)
      render json: CustomerSerializer.new(@customer).as_json
    else
      render json: ErrorSerializer.new(
        message: "Customer could not be updated",
        errors: @customer.errors.full_messages
      ).as_json, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy
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
    @customer = User.customer.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: ErrorSerializer.new(message: "Customer not found").as_json, status: :not_found
  end

  def customer_params
    params.permit(:name, :phone, :email)
  end

  def customer_update_params
    params.permit(:name, :phone, :email, :password)
  end
end
