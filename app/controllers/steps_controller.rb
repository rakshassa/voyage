class StepsController < ApplicationController
  before_action :set_step, only: [:show, :edit, :update, :destroy]
  before_action :set_quest, only: [:new, :create]


  # GET /steps/1
  def show
  end

  # GET /steps/new
  def new
    redirect_to quests_path if @quest.nil?
    @step = Step.new
  end

  # GET /steps/1/edit
  def edit
  end

  # POST /steps
  def create
    @step = Step.new(step_params)
    @quest = @step.quest

    respond_to do |format|
      if @step.valid? && @step.save
        format.html { redirect_to edit_quest_path(@quest), notice: 'Step was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /steps/1

  def update
    @quest = @step.quest
    respond_to do |format|
      if @step.update(step_params)
        format.html { redirect_to edit_quest_path(@quest), notice: 'Step was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /steps/1
  def destroy
    @quest = @step.quest
    @step.destroy
    respond_to do |format|
      format.html { redirect_to edit_quest_path(@quest), notice: 'Step was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_step
      @step = Step.find(params[:id])
    end

    def set_quest
      @quest = nil
      quest_id = params[:quest_id]
      return nil unless quest_id.present?

      quest_records = Quest.where(id: quest_id)
      return nil unless quest_records.present?

      @quest = quest_records.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def step_params
      params.require(:step).permit(:step_number, :points, :name, :quest_id)
    end
end
