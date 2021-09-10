require 'active_ldap/association/has_many_wrap'

module ActiveLdap
  module Association
    class HasManyWrap < Collection
      unless private_instance_methods.include?(:_find_target)
        alias _find_target find_target
        private :_find_target
      end

      private def find_target
        targets, requested_targets = collect_targets(@options[:wrap], true)
        return [] if targets.nil?

        found_targets = {}
        _foreign_key = foreign_key
        targets.each do |target|
          found_targets[target[_foreign_key]] ||= target
        end

        klass = foreign_class
        requested_targets.collect do |name|
          # orgininal code is newing klass
          # found_targets[name] || klass.new(name)
          # no klass
          found_targets[name]
        end.compact
      end
    end
  end
end
