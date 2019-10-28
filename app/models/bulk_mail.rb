# frozen_string_literal: true

require 'mustache'
require 'nkf'

class BulkMail < ApplicationRecord
  STATUS_LIST = %w[
    draft
    pending
    reserved
    ready
    waiting
    delivering
    delivered
    failed
    discarded
  ].freeze

  TIMING_LIST = %w[
    immediate
    reserved
    manual
  ].freeze

  ACTION_LIST = %w[
    create
    edit
    update
    destroy
    apply
    withdraw
    approve
    reject
    reserve
    deliver
    finish
    discard
  ].freeze

  belongs_to :bulk_mail_template
  belongs_to :user
  has_many :bulk_mail_actions, dependent: :destroy

  validates :user, presence: true
  validates :bulk_mail_template, presence: true

  validates :delivery_timing, inclusion: {in: TIMING_LIST}
  validates :subject, presence: true, length: {maximum: 255}
  validates :body, presence: true, length: {maximum: 65536}

  # validates :delivery_datetime
  validates :number, numericality: {only_integer: true, greater_than: 0},
                     allow_nil: true
  validates :status, inclusion: {in: STATUS_LIST}

  validate :subject_can_contert_to_jis, :body_can_contert_to_jis

  before_save :adjust_chars

  def subject_prefix
    Mustache.render(bulk_mail_template.subject_prefix || '', individual_values)
  end

  def subject_postfix
    Mustache.render(bulk_mail_template.subject_postfix || '', individual_values)
  end


  def body_header
    text = Mustache.render(bulk_mail_template.body_header || '',
                           individual_values)
    if text&.present? && !text.end_with?("\n")
      text + "\n"
    else
      text
    end
  end

  def body_footer
    text = Mustache.render(bulk_mail_template.body_footer || '',
                           individual_values)
    if text&.present? && !text.end_with?("\n")
      text + "\n"
    else
      text
    end
  end

  private
    def individual_values
      number_str = number&.to_s || "0"
      datetime = delivery_datetime || DateTime.now
      @individual_values ||= {
        number: number_str,
        number_zen: number_str.tr('0-9', '０-９'),
        number_kan: number_str.tr('0-9', '〇一ニ三四五六七八九'),
        name: bulk_mail_template.name,
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
