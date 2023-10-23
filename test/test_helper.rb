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
