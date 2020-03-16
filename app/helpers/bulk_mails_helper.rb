# frozen_string_literal: true

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
end
