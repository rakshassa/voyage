class QuestsController < ApplicationController
  before_action :ensure_admin
  before_action :set_quest, only: [:edit, :update, :destroy, :publish, :unpublish, :addprereq, :removeprereq]

  def addprereq
    Rails.logger.error "Inside adding prereq"
    required_quest_id = params[:required_quest_id]

    # Make sure we don't already have this prereq
    unless @quest.prereqs.where(required_quest_id: required_quest_id).present?
      # Make sure the prereq quest_id actually exists
      if Quest.where(id: required_quest_id).present?
        prereq = @quest.prereqs.build(required_quest_id: required_quest_id)
        prereq.save
      end
    end

    redirect_to edit_quest_path(@quest)
  end

  def removeprereq
    Rails.logger.error "Inside adding prereq"
    prereq_id = params[:prereq_id]

    prereq = Prereq.where(id: prereq_id)
    if prereq.present?
      prereq.first.destroy
    end

    redirect_to edit_quest_path(@quest)
  end

  def publish
    Teamquest.publish(@quest)

    @quest.is_published = true
    @quest.save
    redirect_to quests_path
  end

  def unpublish
    Teamquest.unpublish(@quest, true)

    @quest.is_published = false
    @quest.save
    redirect_to quests_path
  end

  # GET /quests
  def index
    @quests = Quest.all
  end

  # GET /quests/new
  def new
    @quest = Quest.new
  end

  # GET /quests/1/edit
  def edit
    @prereq_choices = Quest.not_prereq_of(@quest.id)
  end

  # POST /quests
  def create
    @quest = Quest.new(quest_params)
    @quest.is_published = false

    respond_to do |format|
      if @quest.save
        format.html { redirect_to quests_path, notice: 'Quest was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /quests/1
  def update
    respond_to do |format|
      if @quest.update(quest_params)
        format.html { redirect_to quests_path, notice: 'Quest was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /quests/1
  def destroy
    @quest.destroy
    respond_to do |format|
      format.html { redirect_to quests_url, notice: 'Quest was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quest
      @quest = Quest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quest_params
      params.require(:quest).permit(:name)
    end
end
