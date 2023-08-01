class SearchesController < ApplicationController
  before_action :authorize_search

  # GET /search/new
  # GET /search/new.json
  def new
    @query = ''
  end

  # POST /search
  # POST /eserch.json
  def create
    @query = search_params[:query] || ''
    @mail_user = if @query.present?
      if @query.include?('@')
        MailUser.find_by(mail: @query)
      else
        MailUser.find_by(name: @query)
      end
    end
  end

  private def authorize_search
    authorize MailUser, :search?
  end

  private def search_params
    params.permit(:query)
  end
end
