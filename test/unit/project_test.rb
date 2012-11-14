require 'test_helper'

SimpleCov.command_name "test:units"

class ProjectTest < ActiveSupport::TestCase
  test "scopes" do
    # test owner, scorer, manager scopes
    p1 = create(:project)
    p2 = create(:project)

    assert_equal 1, Project.current.with_manager(p1.managers.first).length
    assert_equal 1, Project.current.with_manager(p2.managers.first).length
    assert_equal p2, Project.current.with_manager(p2.managers.first).first

    assert_equal 1, Project.current.with_scorer(p1.scorers.first).length
    assert_equal 1, Project.current.with_scorer(p2.scorers.first).length
    assert_equal p2, Project.current.with_scorer(p2.scorers.first).first

    assert_equal 1, Project.current.with_owner(p1.owner).length
    assert_equal 1, Project.current.with_owner(p2.owner).length
    assert_equal p2, Project.current.with_owner(p2.owner).first
  end

  test "manager and scorer associations" do
    u = create(:user)
    managers = create_list :user, 2
    scorers = create_list :user, 4
    m_ids = managers.map{|m| m.id}
    s_ids = scorers.map{|s| s.id}

    p = u.owned_projects.new(name: "test_p")
    p.save

    p.manager_ids = m_ids
    p.scorer_ids = s_ids
    p.save

    assert_equal 2, p.managers.length
    assert_equal 4, p.scorers.length
  end

end
