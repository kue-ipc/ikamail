class PagesController < ApplicationController
  def top
    authorize current_user, :user?

    @approval_pending_count = BulkMail.includes(:mail_template)
      .where(mail_template: {user: current_user}, status: :pending).count

    @mail_counts = [
      :draft,
      :pending,
      :ready,
      :reserved,
      :waiting,
      :delivering,
      :delivered,
      :waste,
      :failed,
      :error,
    ].index_with do |status|
      policy_scope(BulkMail).where(status: status).count
    end
  end
end
