class UserSerializer
  def initialize(user)
    @user = user
  end

  def as_json
    result = {
      id: @user.id,
      name: @user.name,
      email: @user.email,
      phone: @user.phone,
      role: @user.role,
      created_at: @user.created_at,
      matters_count: @user.matters.count,
      pending_matters_count: @user.matters.pending.count,
      in_progress_matters_count: @user.matters.in_progress.count,
      completed_matters_count: @user.matters.completed.count
    }

    result[:firm_name] = @user.firm_name if @user.admin?

    result
  end
end
