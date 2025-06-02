class CustomerSerializer
  def initialize(customer)
    @customer = customer
  end
  
  def as_json
    {
      id: @customer.id,
      name: @customer.name,
      phone: @customer.phone,
      email: @customer.email,
      created_at: @customer.created_at,
      updated_at: @customer.updated_at,
      matters_count: @customer.matters.count,
      pending_matters_count: @customer.matters.pending.count,
      in_progress_matters_count: @customer.matters.in_progress.count,
      completed_matters_count: @customer.matters.completed.count
    }
  end
end