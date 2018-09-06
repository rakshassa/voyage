class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def edit
    return redirect_to root_path unless current_user.present? && @user.present?
    return redirect_to root_path unless @user.id == current_user.id
  end

  # PATCH/PUT /quests/1
  def update
    return redirect_to root_path unless current_user.present? && @user.present?
    return redirect_to root_path unless @user.id == current_user.id

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_path, notice: 'We managed to save your data.' }
      else
        format.html { render :edit }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:handle)
    end
end
