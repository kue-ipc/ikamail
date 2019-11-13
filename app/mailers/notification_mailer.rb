# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  default charset: 'ISO-2022-JP'

  before_action :mail_params

  def mail_apply
    mail to: @to.map(&:email)
  end

  def mail_approve
    mail to: @to.map(&:email)
  end

  def mail_reject
    mail to: @to.map(&:email)
  end

  def mail_cancel
    mail to: @to.map(&:email)
  end

  def mail_finish
    mail to: @to.map(&:email)
  end

  def mail_fail
    mail to: @to.map(&:email)
  end

  def mail_error
    mail to: @to.map(&:email)
  end

  private

    def mail_params
      @to = [*params[:to]]
      @bulk_mail = params[:bulk_mail]
      @comment = params[:comment]
    end
end
