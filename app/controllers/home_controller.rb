class HomeController < ApplicationController
  def show
    return redirect_to(dashboard_team_path(current_user.team)) if current_user && current_user.team.present?
  end
end
