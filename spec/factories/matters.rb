FactoryBot.define do
  factory :matter do
    title { "New Project" }
    description { "Project is cool" }
    state { "new" }
    due_date { 1.week.from_now }
    association :user
    
    trait :pending do
      state { "new" }
    end
    
    trait :in_progress do
      state { "in_progress" }
    end
    
    trait :completed do
      state { "completed" }
    end
    
    trait :overdue do
      due_date { 1.week.ago }
    end
    
    trait :due_today do
      due_date { Date.current.end_of_day }
    end
  end
end