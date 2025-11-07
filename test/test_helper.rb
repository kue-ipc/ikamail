ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"

require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # pundit policy helper
    def assert_permit(user, record, action)
      msg = "User #{user.username} should be permitted to #{action} #{record}, but isn't permitted"
      assert permit(user, record, action), msg
    end

    def assert_not_permit(user, record, action)
      msg = "User #{user.username} should NOT be permitted to #{action} #{record}, but is permitted"
      assert_not permit(user, record, action), msg
    end

    def permit(user, record, action)
      cls = self.class.name.delete_suffix("Test")
      cls.constantize.new(user, record).public_send("#{action}?")
    end
  end
end

# nkf helper
require "nkf"

def u8tojis(str)
  NKF.nkf("-W -j", str).force_encoding(Encoding::US_ASCII)
end

def u8tomjis(str)
  NKF.nkf("-W -j -M", str).force_encoding(Encoding::US_ASCII)
end

def jistou8(str)
  NKF.nkf("-J -w", str)
end

def mjistou8(str)
  NKF.nkf("-J -w -m", str)
end

def read_fixture_mail(filename)
  u8tojis(read_fixture(filename).join.gsub(/\R/, "\r\n"))
end

def all_emails_for(bulk_mail)
  bulk_mail.mail_template.recipient_list.applicable_mail_users.map(&:mail)
    .union([bulk_mail.mail_template.user.email, bulk_mail.user.email])
end
