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
    return redirect_to root_path unless Prereq.is_available(@teamquest.team, @teamquest.quest)
    return redirect_to root_path unless @teamquest.quest.is_published

    return redirect_to root_path unless @teamquest.is_step_completed(@step.step_number) || @teamquest.is_next_step(@step.step_number)
  end

  def answer
    return redirect_to root_path unless @teamquest.present?
    return redirect_to root_path unless current_user.team_id == @teamquest.team_id
    return redirect_to root_path unless @teamquest.is_available
    return redirect_to root_path unless @step.present?
    return redirect_to root_path unless Prereq.is_available(@teamquest.team, @teamquest.quest)
    return redirect_to root_path unless @teamquest.quest.is_published

    return redirect_to root_path unless @teamquest.is_next_step(@step.step_number)

    @answer_result = "Wrong!  Try again..."

    answer = conform_answer(params[:answer])

    if answer == @step.answer.downcase
      @answer_result = "Correct!  Well done!"
      @teamquest.last_step_completed = @step.step_number
      @teamquest.save
      flash[:notice] = "Correct!  Well done!"
      Prereq.complete_quest(@teamquest) if @teamquest.is_all_steps_completed
      return redirect_to teamquest_path(id: @teamquest.id)
    end

    render :step
  end

  private
    def conform_answer(answer)
      return nil unless answer.present?
      answer.strip.downcase
    end

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
