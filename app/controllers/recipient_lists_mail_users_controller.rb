class RecipientListsMailUsersController < ApplicationController
  def index
    @recipient_list = RecipientList.find(params[:recipient_list_id])
    @mail_users = @recipient_list.mail_users
  end
end
