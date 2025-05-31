class UserSerializer
  def initialize(user)
    @user = user
  end
  
  def as_json
    {
      id: @user.id,
      name: @user.name,
      email: @user.email,
      created_at: @user.created_at,
      matters_count: @user.matters.count,
      pending_matters_count: @user.pending_matters.count,
      in_progress_matters_count: @user.in_progress_matters.count,
      completed_matters_count: @user.completed_matters.count
    }
  end
end