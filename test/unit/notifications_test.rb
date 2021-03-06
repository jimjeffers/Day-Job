require 'test_helper'

class NotificationsTest < ActionMailer::TestCase
  test "invitation" do
    @expected.subject = 'Notifications#invitation'
    @expected.body    = read_fixture('invitation')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_invitation(@expected.date).encoded
  end

  test "forgot_password" do
    @expected.subject = 'Notifications#forgot_password'
    @expected.body    = read_fixture('forgot_password')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_forgot_password(@expected.date).encoded
  end

end
