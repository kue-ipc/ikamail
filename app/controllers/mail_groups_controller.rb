class MailGroupsController < ApplicationController
  before_action :set_mail_group, only: [:show]
  before_action :authorize_mail_group, only: [:index]

  # GET /mail_groups
  # GET /mail_groups.json
  def index
    @mail_groups = policy_scope(MailGroup).order(:name).page(params[:page])
  end

  # GET /mail_groups/1
  # GET /mail_groups/1.json
  def show
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_mail_group
      @mail_group = MailGroup.find(params[:id])
      authorize @mail_group
    end

    def authorize_mail_group
      authorize MailGroup
    end
end
