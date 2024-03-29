class SearchesController < ApplicationController
  before_action :authorize_search

  # GET /search/new
  # GET /search/new.json
  def new
    @query = ""
  end

  # POST /search
  # POST /eserch.json
  def create
    @query = search_params[:query]&.downcase || ""
    @mail_user = if @query.present?
      if @query.include?("@")
        policy_scope(MailUser).find_by(mail: @query)
      else
        policy_scope(MailUser).find_by(name: @query)
      end
    end
  end

  private def authorize_search
    authorize MailUser, :search?
  end

  private def search_params
    params.require(:search).permit(:query)
  end
end
