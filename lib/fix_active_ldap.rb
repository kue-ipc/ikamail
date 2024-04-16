require "active_ldap/association/has_many_wrap"

module FixActiveLdap
  def self.load
    unless ActiveLdap::Association::HasManyWrap.private_instance_methods
        .include?(:_find_target)
      ActiveLdap::Association::HasManyWrap.alias_method :_find_target,
        :find_target
    end

    ActiveLdap::Association::HasManyWrap.class_eval do
      # rubocop: disable Lint/UnderscorePrefixedVariableName
      private def find_target
        targets, requested_targets = collect_targets(@options[:wrap], true)
        return [] if targets.nil?

        found_targets = {}
        _foreign_key = foreign_key
        targets.each do |target|
          found_targets[target[_foreign_key]] ||= target
        end

        # --- original code ---
        # klass = foreign_class
        # requested_targets.collect do |name|
        #   found_targets[name] || klass.new(name)
        # end

        requested_targets.collect { |name|
          found_targets[name]
        }.compact
      end
      # rubocop: enable Lint/UnderscorePrefixedVariableName
    end
  end
end

# module ActiveLdap
#   module Association
#     class HasManyWrap < Collection
#       unless private_instance_methods.include?(:_find_target)
#         alias _find_target find_target
#         private :_find_target
#       end

#
#       private def find_target
#         targets, requested_targets = collect_targets(@options[:wrap], true)
#         return [] if targets.nil?

#         found_targets = {}
#         _foreign_key = foreign_key
#         targets.each do |target|
#           found_targets[target[_foreign_key]] ||= target
#         end

#         # --- original code ---
#         # klass = foreign_class
#         # requested_targets.collect do |name|
#         #   found_targets[name] || klass.new(name)
#         # end

#         requested_targets.collect { |name|
#           found_targets[name]
#         }.compact
#       end
#       #     end
#   end
# end
