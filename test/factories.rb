
FactoryGirl.define do

  ##
  # Users

  factory :user, aliases: [:creator, :owner] do
    first_name "John"
    sequence(:last_name) { |n| "Doe_#{n}" }
    password "secret"
    sequence(:email) {|n| "user_#{n}@example.com" }
    system_admin false
    status "active"
  end

  # This will use the User class (Admin would have been guessed)
  #factory :admin, class: User do
  #  first_name "Admin"
  #  last_name  "User"
  #  password "secret"
  #  sequence(:email) {|n| "admin_#{n}@example.com" }
  #  system_admin true
  #  status "active"
  #end

  ##
  # Exercises
  factory :exercise do
    owner
    sequence(:name) {|n| "Test Exercise #{n}"}
    description "Description of test exercise."

    ignore do
      scorer_count 3
      group_count 2
      existing_project_id nil
    end

    before(:create) do |exercise, evaluator|
      if evaluator.existing_project_id
        project = Project.find(evaluator.existing_project_id)
      else
        project = create(:project, scorer_count: evaluator.scorer_count + 1, group_count: evaluator.group_count + 1)
      end

      exercise.project = project
      exercise.rule = project.rules.first
      exercise.scorers = project.scorers[0..project.scorers.length-2]
      exercise.groups = project.groups[0..project.groups.length-2]
    end
  end

  ##
  # Project

  factory :project do
    owner
    sequence(:name) {|n| "Project_#{n}"}
    description "Some description for what this project is about."
    start_date { Date.today() }
    end_date { Date.today() + 1.month }

    ignore do
      rule_count 2
      scorer_count 4
      manager_count 2
      study_count 5
      group_count 3
    end

    before(:create) do |project, evaluator|
      rules = create_list :rule, evaluator.rule_count
      scorers = create_list :user, evaluator.scorer_count
      managers = create_list :user, evaluator.manager_count

      evaluator.group_count.times do
        studies = create_list :study, evaluator.study_count
        group = create(:group, study_ids: studies.map{|s| s.id})

        project.groups << group
        project.studies << studies
      end

      project.rules = rules
      project.scorers = scorers
      project.managers = managers
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

    factory :study_with_original_results do
      ignore do
        result_count 2
      end

      after(:create) do |study, evaluator|
        create_list :study_original_result, evaluator.result_count, study_id: study.id
      end
    end
  end

  ##
  # Rules
  factory :rule do
    sequence(:title) {|n| "Scoring Rule #{n}"}
    procedure "Procedure for this scoring rule."
    assessment_type "paradox"
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
    sequence(:location) {|n| "/path/to/result/location/#{n}" }
    result_type "test_result_type"
    assessment
  end

  factory :study_original_result do
    study
    result
    rule
  end

  ##
  # Reliability Ids
  factory :reliability_id do
    study
    user
    exercise
  end

  ##
  # Assessments
  factory :assessment do
    assessment_type "paradox"

    after(:create) do |assessment, evaluator|
      create(:assessment_result, assessment_id: assessment.id, question_id: 1, answer: 20)
      create(:assessment_result, assessment_id: assessment.id, question_id: 2, answer: 3)
    end
  end

  ##
  # Assessment Results
  factory :assessment_result do
    sequence(:question_id) { |n| n }
    answer "Some answer to a question"
  end

end