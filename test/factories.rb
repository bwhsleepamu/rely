
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
      exercise.owner = project.managers.first
      exercise.updater_id = project.managers.first.id
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
      study_type_count 3
    end

    after(:create) do |project, evaluator|
      scorers = create_list :user, evaluator.scorer_count
      managers = create_list :user, evaluator.manager_count
      project.scorers = scorers
      project.managers = managers
      m = managers.first

      study_types = create_list :study_type, evaluator.study_type_count, project: project, creator: m, updater_id: m.id
      rules = create_list :rule, evaluator.rule_count, project: project, creator: m, updater_id: m.id

      0.upto(evaluator.group_count - 1) do |i|
        i >= study_types.length ? study_type = study_types.first : study_type = study_types[i]

        studies = create_list :study, evaluator.study_count, project: project, study_type: study_type, creator: m, updater_id: m.id
        group = create(:group, study_ids: studies.map{|s| s.id}, project: project, creator: m, updater_id: m.id)
      end
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
    creator

    factory :study_with_original_results do

      after(:create) do |study, evaluator|
        study.project.rules.each do |rule|
          sor = create :study_original_result, study_id: study.id, rule_id: rule.id
          #MY_LOG.info "GRRR: #{study.study_original_results} #{study.original_results} #{sor.study.id}"

          #MY_LOG.info "#{sor} #{sor.valid?} #{sor.errors.full_messages} #{sor.study} #{sor.rule} #{sor.rule.valid?}"
        end
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
    result
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

  ##
  # Assets
  factory :asset do
    asset File.open("test/data/upload.txt")
  end

end