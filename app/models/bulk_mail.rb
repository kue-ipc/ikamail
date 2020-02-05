# frozen_string_literal: true

require 'mustache'
require 'iso2022jp'

class BulkMail < ApplicationRecord
  include Iso2022jp

  enum status: {
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
  }, _prefix: true

  enum delivery_timing: {
    immediate: 0,
    reserved: 1,
    manual: 2,
  }, _prefix: true

  belongs_to :template
  belongs_to :user
  has_many :action_logs, dependent: :destroy

  validates :user, presence: true
  validates :template, presence: true

  validates :delivery_timing, presence: true
  validates :subject, presence: true, length: {maximum: 255}, charcode: true
  validates :body, presence: true, length: {maximum: 65536}, charcode: true

  # validates :delivery_datetime
  validates :number, numericality: {only_integer: true, greater_than: 0},
                     allow_nil: true
  validates :status, presence: true

  # validate :subject_can_contert_to_jis, :body_can_contert_to_jis

  before_save :adjust_chars

  def subject_all
    subject_prefix + subject + subject_suffix
  end

  def body_all
    body_header + body + body_footer
  end

  def subject_prefix
    Mustache.render(template.subject_prefix || '', individual_values)
  end

  def subject_suffix
    Mustache.render(template.subject_suffix || '', individual_values)
  end

  def body_header
    Mustache.render(template.body_header || '', individual_values)
  end

  def body_footer
    Mustache.render(template.body_footer || '', individual_values)
  end

  private

    def individual_values
      number_str = (number || 0).to_s
      datetime = delivered_at || Time.current
      @individual_values ||= {
        number: number_str,
        number_zen: number_str.tr('0-9', '０-９'),
        number_kan: number_str.tr('0-9', '〇一ニ三四五六七八九'),
        name: template.name,
        datetime: I18n.l(datetime, format: :datetime),
        date: I18n.l(datetime, format: :date),
        time: I18n.l(datetime, format: :time),
      }
    end

    def adjust_chars
      self.subject = double_conv_jis(subject)
      self.body = double_conv_jis(body)

      self.body += "\n" if body.present? && !body.end_with?("\n")
    end
end
