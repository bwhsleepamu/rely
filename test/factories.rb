
FactoryGirl.define do

  ##
  # Users

  factory :user, aliases: [:creator] do
    first_name "John"
    sequence(:last_name) { |n| "Doe_#{n}" }
    password "secret"
    sequence(:email) {|n| "user_#{n}@example.com" }
    system_admin false
    status "active"
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    first_name "Admin"
    last_name  "User"
    password "secret"
    sequence(:email) {|n| "admin_#{n}@example.com" }
    system_admin true
    status "active"
  end

  ##
  # Exercises
  factory :exercise do
    admin
    rule
    assessment_type "paradox"
    sequence(:name) {|n| "Test Exercise #{n}"}
    description "Description of test exercise."

    ignore do
      user_count 3
      group_count 2
    end

    before(:create) do |exercise, evaluator|
      scorers = create_list :user, evaluator.user_count
      groups = create_list :group_with_studies, evaluator.group_count

      exercise.scorers = scorers
      exercise.groups = groups
    end
  end

  ##
  # Study Types
  factory :study_type do
    sequence(:name) {|n| "Type of Study #{n}"}
    description "Some description of this type of study."
    creator
  end

  ##
  # Studies
  factory :study do
    sequence(:original_id) {|n| "123JK#{n}"}
    location "/path/to/some/location/of/file.csv"
    study_type
    creator

  end

  ##
  # Rules
  factory :rule do
    sequence(:title) {|n| "Scoring Rule #{n}"}
    procedure "Procedure for this scoring rule."
    creator
  end

  ##
  # Groups
  factory :group do
    sequence(:name) {|n| "Group #{n}"}
    description "Describes this amazing group of awesomeness"

    factory :group_with_studies do

      ignore do
        study_count 3
      end

      after(:create) do |group, evaluator|
        create_list :study, evaluator.study_count, groups: [group]
      end
    end
  end

  ##
  # Results
  factory :result do
    location "/path/to/result/location"
    result_type "test_result_type"
    #user
    #exercise
    #study
    #rule
    assessment
  end

  ##
  # Assessments
  factory :assessment do
    assessment_type "paradox"

    ignore do
      assessment_result_count 2
    end

    after(:create) do |assessment, evaluator|
      create_list(:assessment_result, evaluator.assessment_result_count, assessment_id: assessment.id)
    end
  end

  ##
  # Assessment Results
  factory :assessment_result do
    sequence(:question_id) { |n| n }
    answer "Some answer to a question"
  end

end