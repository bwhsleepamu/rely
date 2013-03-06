require 'test_helper'

class AssetsControllerTest < ActionController::TestCase

  ##
  # Downloads

  # Single Asset can be downloaded:
  #   - By scorer who uploaded asset to exercise result (reliablility_id)
  #   - By manager of project to which study with given original result belongs (study_original_result)
  #   - By manager of exercise to which result belongs (reliablity_id --> exercise --> managers)

  # Multiple Assets (zipped) can be downloaded:
  #   - By scorer
  #   - By manager (SAME!)
  #   - By manager

  test "should bulk-download exercise" do
    r = setup_asset_tests
    u = r[:manager]

    login(u)
    get :download_zip, :exercise_id => u.all_exercises.first.id
    assert_response(:success)
    assert @response.body.present?
  end

  test "should bulk-download result" do
    r = setup_asset_tests
    u = r[:manager]

    login(u)
    get :download_zip, :result_id => u.all_exercises.first.all_results.first.id
    assert_response(:success)
    assert @response.body.present?

  end

  test "should bulk-download reliability id" do
    pending "Not needed at this moment"

    r = setup_asset_tests
    u = r[:scorer]

    login(u)
    get :download_zip, :reliability_id => u.reliability_ids.first.id
    assert_response(:success)
    assert @response.body.present?

  end

  test "should bulk-download study" do
    pending "Not needed at this moment"
    r = setup_asset_tests
    u = r[:manager]

    login(u)
    get :download_zip, :study_id => u.all_exercises.first.all_studies.first.id
    assert_response(:success)
    assert @response.body.present?
  end

  test "should allow scorer who uploaded asset to download it" do
    r = setup_asset_tests
    u = r[:scorer]
    a = u.all_results.first.assets.first

    login(u)

    get :download, :id => a
    assert_response(:success)
    assert_equal @response.body, "THIS IS A TEST UPLOAD FILE YO"
  end

  test "should allow manager to download original result asset" do
    r = setup_asset_tests
    u = r[:manager]
    a = u.all_original_results.first.assets.first

    login(u)

    get :download, :id => a
    assert_response(:success)
    assert_equal @response.body, "THIS IS A TEST UPLOAD FILE YO"
  end

  test "should allow manager to download exercise result asset" do
    r = setup_asset_tests
    u = r[:manager]
    a = u.all_exercise_results.first.assets.first

    login(u)

    get :download, :id => a
    assert_response(:success)
    assert_equal @response.body, "THIS IS A TEST UPLOAD FILE YO"
  end

  test "should not allow an asset to be downloaded by random user" do
    login(create(:user))
    asset = create(:asset)
    get :download, :id => asset
    assert_response(:success)
    assert @response.body.blank?
  end

  def setup_asset_tests
    p = create(:project)
    e = create(:exercise, existing_project_id: p.id)
    result_count = {total: 0, exercise: 0, rid: 0, original: 0}

    scorer = e.scorers.first

    e.reliability_ids.each do |rid|
      rid.result = build(:result)
      rid.result.assets << build(:asset)
      rid.save
      result_count[:total] += 1
      result_count[:rid] += 1
      result_count[:exercise] += 1 if rid.user == scorer
    end

    p.studies.each do |s|
      p.rules.each do |r|
        sor = StudyOriginalResult.new
        sor.rule = r
        sor.result = build(:result)
        sor.result.assets << build(:asset)
        result_count[:total] += 1
        result_count[:original] += 1
        s.study_original_results << sor
        s.save
      end
    end

    assert e.project == p

    {manager: p.managers.first, scorer: scorer, count: result_count}
  end
end
