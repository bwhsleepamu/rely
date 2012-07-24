
FactoryGirl.define do

  ##
  # USERS

  factory :user do
    first_name "John"
    last_name "Doe"
    password "secret"
    sequence(:email) {|n| "user_#{n}@example.com" }
    system_admin false
    deleted false
    status "active"
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    first_name "Admin"
    last_name  "User"
    password "secret"
    sequence(:email) {|n| "admin_#{n}@example.com" }
    system_admin true
    deleted false
    status "active"
  end

  ##
  # Exercises
  factory :exercise do

  end

end