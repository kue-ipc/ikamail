class PagesController < ApplicationController
  def top
    authorize current_user, :user?
  end
end
