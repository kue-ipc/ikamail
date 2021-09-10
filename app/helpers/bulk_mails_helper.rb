module BulkMailsHelper
  def template_to_hash(templates)
    templates.map do |template|
      [
        template.id,
        {
          name: template.name,
          user: template.user.name,
          recipient_list: template.recipient_list.name,
          reserved_time: l(template.reserved_time, format: :time),
        }
      ]
    end.to_h
  end

  def wrap_col_collection
    [0, 76, 80].map { |num| [t('helpers.wrap_cols', count: num), num] }
  end

  def wrap_rule_collection
    BulkMail.wrap_rules.keys.map do |name|
      [t(name, scope: [:helpers, :wrap_rules]), name]
    end
  end
end
