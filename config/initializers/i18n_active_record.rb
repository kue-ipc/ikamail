require 'i18n/backend/active_record'

Translation = I18n::Backend::ActiveRecord::Translation

begin
  if Translation.table_exists?
    I18n.backend = I18n::Backend::ActiveRecord.new

    I18n::Backend::ActiveRecord.send(:include, I18n::Backend::Memoize)
    I18n::Backend::Simple.send(:include, I18n::Backend::Memoize)
    I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)

    I18n.backend = I18n::Backend::Chain.new(I18n.backend, I18n::Backend::Simple.new)
  end
rescue ActiveRecord::NoDatabaseError
  # skip before create a database
end

I18n::Backend::ActiveRecord.configure do |config|
  # config.cleanup_with_destroy = true # defaults to false
end
