class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def edit
    return redirect_to root_path unless current_user.present? && @user.present?
    return redirect_to root_path unless @user.id == current_user.id || current_user.is_admin
  end

  # PATCH/PUT /quests/1
  def update
    return redirect_to root_path unless current_user.present? && @user.present?
    return redirect_to root_path unless @user.id == current_user.id || current_user.is_admin

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
      if params[:user].present? && params[:user].key?(:password)
        if !current_user.is_admin || params[:user][:password].blank?
          params[:user].delete :password
        end
      end

      if params[:user].present? && params[:user].key?(:name)
        if !current_user.is_admin || params[:user][:name].blank?
          params[:user].delete :name
        end
      end

      params.require(:user).permit(:name, :handle, :password)
    end
end
