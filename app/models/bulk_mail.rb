require "mustache"
require "iso2022jp"
require "japanese_wrap"

class BulkMail < ApplicationRecord
  include Iso2022jp
  include JapaneseWrap

  enum :status, {
    draft: 0,
    pending: 1,
    ready: 2,
    reserved: 3,
    waiting: 4,
    delivering: 5,
    delivered: 6,
    waste: 7,
    failed: 8,
    error: 9,
  }, prefix: true

  enum :delivery_timing, {
    reserved: 1,
    immediate: 0,
    manual: 2,
  }, prefix: true

  enum :wrap_rule, {
    force: 0,
    word_wrap: 1,
    jisx4051: 2,
  }, prefix: true

  belongs_to :mail_template
  belongs_to :user
  has_many :action_logs, dependent: :destroy

  # NOTE: `presence: true`を外すとテストに失敗する。
  # rubocop: disable Rails/RedundantPresenceValidationOnBelongsTo
  validates :user, presence: true
  validates :mail_template, presence: true
  # rubocop: enable Rails/RedundantPresenceValidationOnBelongsTo

  validates :delivery_timing, presence: true
  validates :subject, presence: true, length: {maximum: 255}, charcode: true
  validates :body, presence: true, length: {maximum: 65_536}, charcode: true

  # validates :delivery_datetime
  validates :number, numericality: {only_integer: true, greater_than: 0},
    allow_nil: true
  validates :status, presence: true

  # validate :subject_can_contert_to_jis, :body_can_contert_to_jis

  validates :wrap_col, numericality: {only_integer: true},
    inclusion: {in: [0, 76, 80]}

  before_save :adjust_chars

  def subject_all
    subject_prefix + subject + subject_suffix
  end

  def body_all
    body_header + body_wrap + body_footer
  end

  def body_wrap
    text_wrap(body, col: wrap_col, rule: wrap_rule.intern)
  end

  def subject_prefix
    return "" if mail_template.subject_prefix.blank?

    Mustache.render(mail_template.subject_prefix, individual_values)
  end

  def subject_suffix
    return "" if mail_template.subject_suffix.blank?

    Mustache.render(mail_template.subject_suffix, individual_values)
  end

  def body_header
    return "" if mail_template.body_header.blank?

    text_wrap(
      Mustache.render(mail_template.body_header, individual_values),
      col: wrap_col, rule: wrap_rule.intern)
  end

  def body_footer
    return "" if mail_template.body_footer.blank?

    text_wrap(
      Mustache.render(mail_template.body_footer, individual_values),
      col: wrap_col, rule: wrap_rule.intern)
  end

  private def individual_values
    number_str = (number || 0).to_s
    datetime = delivered_at || Time.current
    @individual_values ||= {
      number: number_str,
      number_zen: number_str.tr("0-9", "０-９"),
      number_kan: number_str.tr("0-9", "〇一ニ三四五六七八九"),
      name: mail_template.name,
      datetime: I18n.l(datetime, format: :datetime),
      date: I18n.l(datetime, format: :date),
      time: I18n.l(datetime, format: :time),
    }
  end

  private def adjust_chars
    self.subject = double_conv_jis(subject)
    self.body = double_conv_jis(body)

    self.body += "\n" if body.present? && !body.end_with?("\n")
  end
end
