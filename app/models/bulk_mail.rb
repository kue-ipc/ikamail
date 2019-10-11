# frozen_string_literal: true

class BulkMail < ApplicationRecord
  STATUS_LIST = %w[
    draft
    pending
    reserved
    ready
    waiting
    delivery
    derivered
    failure
  ]

  TIMING_LIST = %w[
    immediate
    reservation
    manual
  ]

  validates :status, inclusion: {in: STATUS_LIST}
  validates :delivery_timing, inclusion: {in: TIMING_LIST}






  belongs_to :bulk_mail_template
  belongs_to :user

  def mail_subject
    str = String.new
    str << bulk_mail_template.subject_prefix % individual_values
    str << subject
    str << bulk_mail_template.subject_postfix % individual_values
    str
  end

  def mail_body
    str = String.new
    str << bulk_mail_template.body_header % individual_values
    str << body
    str << bulk_mail_template.body_fotter % individual_values
    str
  end

  private def individual_values
    number_str = number.to_s
    {
      num: number_str,
      num_zen: number_str.tr('0-9', '０-９'),
      num_kan: number_str.tr('0-9', '〇一ニ三四五六七八九'),
      name: bulk_mail_template.name,
      date: delivery_datetime.date.to_s,
    }
  end

end
