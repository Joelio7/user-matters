class MatterSerializer
  def initialize(matter)
    @matter = matter
  end
  
  def as_json
    result = {
      id: @matter.id,
      title: @matter.title,
      description: @matter.description,
      state: @matter.state,
      due_date: @matter.due_date,
      user_id: @matter.user_id,
      created_at: @matter.created_at,
      updated_at: @matter.updated_at
    }
    
    if @matter.association(:user).loaded?
      result[:user] = {
        id: @matter.user.id,
        name: @matter.user.name,
        email: @matter.user.email
      }
    end
    
    result
  end
end