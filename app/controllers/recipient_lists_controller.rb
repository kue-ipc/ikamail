class RecipientListsController < ApplicationController
  before_action :set_recipient_list, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_recipient_list, only: [ :index, :new, :create ]

  # GET /recipient_lists
  # GET /recipient_lists.json
  def index
    @recipient_lists = policy_scope(RecipientList).order(:name).page(params[:page])
  end

  # GET /recipient_lists/1
  # GET /recipient_lists/1.json
  def show
  end

  # GET /recipient_lists/new
  def new
    @recipient_list = RecipientList.new
  end

  # GET /recipient_lists/1/edit
  def edit
  end

  # POST /recipient_lists
  # POST /recipient_lists.json
  def create
    @recipient_list = RecipientList.new({ **recipient_list_params,
      collected: false })
    if @recipient_list.save
      CollectRecipientJob.perform_later(@recipient_list)
      redirect_to @recipient_list,
        notice: t_success_action(@recipient_list, :create)
    else
      render :new
    end
  end

  # PATCH/PUT /recipient_lists/1
  # PATCH/PUT /recipient_lists/1.json
  def update
    if @recipient_list.update({ **recipient_list_params, collected: false })
      CollectRecipientJob.perform_later(@recipient_list)
      redirect_to @recipient_list,
        notice: t_success_action(@recipient_list, :update)
    else
      render :edit
    end
  end

  # DELETE /recipient_lists/1
  # DELETE /recipient_lists/1.json
  def destroy
    if @recipient_list.destroy
      redirect_to recipient_lists_url,
        notice: t_success_action(@recipient_list, :destroy)
    else
      redirect_to @recipient_list, alert: [
        t_failure_action(@recipient_list, :destroy),
        *@recipient_list.errors.messages.fetch(:base, [])
      ]
    end
  end

  private def set_recipient_list
    @recipient_list = policy_scope(RecipientList).find(params[:id])
    authorize @recipient_list
  end

  private def authorize_recipient_list
    authorize RecipientList
  end

  private def recipient_list_params
    params.require(:recipient_list).permit(:name, :description,
      mail_group_ids: [])
  end
end
