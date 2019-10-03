class BulkMail < ApplicationRecord
  belongs_to :mail_template
  belongs_to :user
  belongs_to :mail_status

  def mail_subject
    str = String.new
    str << mail_template.subject_pre % individual_values
    str << subject
    str << mail_template.subject_post % individual_values
    str
  end

  def mail_body
    str = String.new
    str << mail_template.body_header % individual_values
    str << body
    str << mail_template.body_fotter % individual_values
    str
  end

  private def individual_values
    number_str = number.to_s
    {
      num: number_str,
      num_zen: number_str.tr('0-9', '０-９'),
      num_kan: number_str.tr('0-9', '〇一ニ三四五六七八九'),
      name: mail_template.name,
      date: delivery_datetime.date.to_s,
    }
  end

end
