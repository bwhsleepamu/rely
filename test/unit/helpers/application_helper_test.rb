require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "should show recent activity" do
    assert recent_activity(nil).kind_of?(String)
    assert recent_activity('').kind_of?(String)
    assert recent_activity(Time.now).kind_of?(String)
    assert recent_activity(Time.now - 12.hours).kind_of?(String)
    assert recent_activity(Time.now - 1.day).kind_of?(String)
    assert recent_activity(Time.now - 2.days).kind_of?(String)
    assert recent_activity(Time.now - 1.week).kind_of?(String)
    assert recent_activity(Time.now - 1.month).kind_of?(String)
    assert recent_activity(Time.now - 6.month).kind_of?(String)
    assert recent_activity(Time.now - 1.year).kind_of?(String)
    assert recent_activity(Time.now - 2.year).kind_of?(String)
  end
end
