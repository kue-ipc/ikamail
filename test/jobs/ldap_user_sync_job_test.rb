require 'test_helper'

class LdapUserSyncJobTest < ActiveJob::TestCase
  test "sync user attribute" do
    LdapUserSyncJob.perform_now

    # emailとfullnameの修正
    assert_equal 'user05@example.jp', User.find(users(:user05).id).email
    assert_equal '鈴木　陽子', User.find(users(:user06).id).fullname
  end

  test "sync user delete" do
    LdapUserSyncJob.perform_now

    # 存在しないユーザーの削除
    deleted_user = User.find(users(:unknown).id)
    assert deleted_user.deleted?
    assert_not_equal 'unknown', deleted_user.username
    assert_equal '#', deleted_user.username.first
  end

  test "sync user not create" do
    LdapUserSyncJob.perform_now

    # 未ログインユーザーが作成されないこと
    assert_nil User.find_by(username: 'user04')
  end
end
