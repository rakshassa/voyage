class TeamquestsController < ApplicationController
  before_action :set_teamquest, only: [:show, :edit, :update, :destroy, :step, :answer]
  before_action :set_step, only: [:step, :answer]
  # GET /teamquest/1
  def show
  end

  def step
    return redirect_to root_path unless @teamquest.present?
    return redirect_to root_path unless current_user.team_id == @teamquest.team_id
    return redirect_to root_path unless @teamquest.is_available
    return redirect_to root_path unless @step.present?
    return redirect_to root_path unless @teamquest.is_step_completed(@step.step_number) || @teamquest.is_next_step(@step.step_number)
  end

  def answer
    return redirect_to root_path unless @teamquest.present?
    return redirect_to root_path unless current_user.team_id == @teamquest.team_id
    return redirect_to root_path unless @teamquest.is_available
    return redirect_to root_path unless @step.present?
    return redirect_to root_path unless @teamquest.is_next_step(@step.step_number)

    @answer_result = "Wrong!  Try again..."

    if params[:answer] == 'asdf'
      @answer_result = "Correct!  Well done!"
      @teamquest.last_step_completed = @step.step_number
      @teamquest.save
    end

    render :step
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teamquest
      @teamquest = Teamquest.find(params[:id])
    end

    def set_step
      @step = nil
      step_id = params[:step_id]
      records = Step.where(id: step_id)
      return unless records.count == 1

      @step = records.first
    end

end