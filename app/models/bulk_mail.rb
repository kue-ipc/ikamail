# frozen_string_literal: true

require 'mustache'
require 'nkf'

class BulkMail < ApplicationRecord
  enum status: %i[
    draft
    pending
    reserved
    ready
    waiting
    delivering
    delivered
    failed
    discarded
  ], _prefix: true

  enum delivery_timing: %i[
    immediate
    reserved
    manual
  ], _prefix: true

  belongs_to :template
  belongs_to :user
  has_many :action_logs, dependent: :destroy

  validates :user, presence: true
  validates :template, presence: true

  validates :delivery_timing, presence: true
  validates :subject, presence: true, length: {maximum: 255}
  validates :body, presence: true, length: {maximum: 65536}

  # validates :delivery_datetime
  validates :number, numericality: {only_integer: true, greater_than: 0},
                     allow_nil: true
  validates :status, presence: true

  validate :subject_can_contert_to_jis, :body_can_contert_to_jis

  before_save :adjust_chars

  def subject_all
    subject_prefix + subject + subject_postfix
  end

  def body_all
    body_header + body + body_footer
  end

  def subject_prefix
    Mustache.render(template.subject_prefix || '', individual_values)
  end

  def subject_postfix
    Mustache.render(template.subject_postfix || '', individual_values)
  end

  def body_header
    Mustache.render(template.body_header || '', individual_values)
  end

  def body_footer
    Mustache.render(template.body_footer || '', individual_values)
  end

  private
    def individual_values
      number_str = number&.to_s || "0"
      datetime = delivery_datetime || DateTime.now
      @individual_values ||= {
        number: number_str,
        number_zen: number_str.tr('0-9', '０-９'),
        number_kan: number_str.tr('0-9', '〇一ニ三四五六七八九'),
        name: template.name,
        datetime: I18n.t(datetime),
        date: I18n.l(datetime, format: :date),
        time: I18n.l(datetime, format: :time),
      }
    end

    def subject_can_contert_to_jis
      invalid_chars = invalid_jis(subject)
      unless invalid_chars.empty?
        errors.add(:subject, "に使用できない文字が含まれています:#{invalid_chars.join(',')}")
      end
    end

    def body_can_contert_to_jis
      invalid_chars = invalid_jis(body)
      unless invalid_chars.empty?
        errors.add(:body, "に使用できない文字が含まれています:#{invalid_chars.join(',')}")
      end
    end

    def invalid_jis(str)
      no_amp_str = str.gsub('&', '&amp;')
      conv_str = double_conv_jis(no_amp_str)
      conv_str.scan(/&\#x(\h{1,6});/i).map { |m| m.first.to_i(16).chr }
    end

    def adjust_chars
      self.subject = double_conv_jis(subject)
      self.body = double_conv_jis(body)
    end

    def double_conv_jis(str)
      NKF.nkf('-J -w', NKF.nkf('-W -j --fb-xml', str))
    end
end
