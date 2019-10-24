# frozen_string_literal: true

class BulkMailsController < ApplicationController
  before_action :set_bulk_mail, only: [:show, :edit, :update, :destroy]
  before_action :authorize_bulk_mail, only: [:index, :new, :create]

  # GET /bulk_mails
  # GET /bulk_mails.json
  def index
    @bulk_mails = policy_scope(BulkMail)
  end

  # GET /bulk_mails/1
  # GET /bulk_mails/1.json
  def show; end

  # GET /bulk_mails/new
  def new
    @bulk_mail = BulkMail.new
  end

  # GET /bulk_mails/1/edit
  def edit; end

  # POST /bulk_mails
  # POST /bulk_mails.json
  def create
    @bulk_mail = BulkMail.new(bulk_mail_params)
    @bulk_mail.status = 'draft'
    @bulk_mail.user = current_user

    respond_to do |format|
      if @bulk_mail.save
        BulkMailAction.create(bulk_mail: @bulk_mail, user: current_user,
                           action: 'create')
        format.html { redirect_to @bulk_mail, notice: t_success_action(:bulk_mail, :create) }
        format.json { render :show, status: :created, location: @bulk_mail }
      else
        format.html { render :new }
        format.json { render json: @bulk_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bulk_mails/1
  # PATCH/PUT /bulk_mails/1.json
  def update
    respond_to do |format|
      if @bulk_mail.update(bulk_mail_params)
        BulkMailAction.create(bulk_mail: @bulk_mail, user: current_user,
                              action: 'update')
        format.html { redirect_to @bulk_mail, notice: t_success_action(:bulk_mail, :update) }
        format.json { render :show, status: :ok, location: @bulk_mail }
      else
        format.html { render :edit }
        format.json { render json: @bulk_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bulk_mails/1
  # DELETE /bulk_mails/1.json
  def destroy
    @bulk_mail.destroy
    # 削除時にログも削除される。
    respond_to do |format|
      format.html {
        redirect_to bulk_mails_url,
                    notice: t(:success_action,
                              scope: [:messages],
                              model: t(:bulk_mail, scope: [:activerecord, :models]),
                              action: t(:destroy, scope: :actions))
      }
      format.json { head :no_content }
    end
  end

  # Acions
  # PATCH /bulk_mails/1/{action}

  # # GET /bulk_mails/1/apply
  # def apply
  #   if @bulk_mail.status == 'draft'
  #     @bulk_mail.update(satus: 'pending')
  #   else
  #   end
  #
  #   action = params.permit(:action)
  #   notice = ''
  #   error = nil
  #   case action
  #   when 'apply'
  #   when 'approve'
  #   when 'dismiss'
  #   when 'withdraw'
  #   when 'cancel'
  #   else
  #   end
  #   respond_to do |format|
  #     if error
  #     format.html { redirect_to @bulk_mail, notice: '' }
  #     format.json { render :show, status: :ok, location: @bulk_mail }
  #
  #     else
  #       format.html { render :edit }
  #       format.json { render json: errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bulk_mail
      @bulk_mail = BulkMail.find(params[:id])
      authorize @bulk_mail
    end

    def authorize_bulk_mail
      authorize BulkMail
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bulk_mail_params
      params.require(:bulk_mail).permit(:bulk_mail_template_id, :delivery_timing, :subject, :body)
    end
end
