# frozen_string_literal: true

class BulkMailActionsController < ApplicationController
  before_action :set_bulk_mail_action, only: [:show, :edit, :update, :destroy]

  # GET /bulk_mail_actions
  # GET /bulk_mail_actions.json
  def index
    @bulk_mail = BulkMail.find(params[:bulk_mail_id])
    autholize @bulk_mail, :show?
    @bulk_mail_actions = @bulk_mail.bulk_mail_actions
  end

  # POST /bulk_mail_actions
  # POST /bulk_mail_actions.json
  def create
    @bulk_mail = BulkMail.find(params[:bulk_mail_id])
    autholize @bulk_mail, :update?
    @bulk_mail_action = BulkMailAction.new(bulk_mail_action_params)

    case @bulk_mail_action.action
    when 'apply'
      apply
    when ''
    end


    respond_to do |format|
      if @bulk_mail_action.save
        format.html { redirect_to @bulk_mail_action, notice: 'Bulk mail action was successfully created.' }
        format.json { render :show, status: :created, location: @bulk_mail_action }
      else
        format.html { render :new }
        format.json { render json: @bulk_mail_action.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bulk_mail_action
      @bulk_mail_action = BulkMailAction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bulk_mail_action_params
      params.require(:bulk_mail_action).permit(:action, :comment)
    end

    def apply
      @bulk_mail.column_update(column_update(status: 'pending'))
    end
end
