module BulkMailsHelper
  def mail_template_to_hash(mail_templates)
    mail_templates.to_h do |mail_template|
      [mail_template.id, {
        name: mail_template.name,
        user: mail_template.user.name,
        recipient_list: mail_template.recipient_list.name,
        reserved_time: l(mail_template.reserved_time, format: :time),
        description: mail_template.description,
      },]
    end
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
