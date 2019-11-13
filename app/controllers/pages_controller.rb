class PagesController < ApplicationController
  def top
    authorize current_user, :user?

    @draft_mails = current_user.bulk_mails.where(status: :draft)



  end
end
