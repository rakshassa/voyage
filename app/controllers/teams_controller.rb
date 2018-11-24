class TeamsController < ApplicationController
  before_action :ensure_auth
  before_action :ensure_admin, only: %i[index edit update export]
  before_action :set_team, only: %i[edit update destroy dashboard request_join details
                                    cancel_join_request accept_join_request deny_join_request
                                    kick quit promote ignore_joins watch_joins]
  before_action :ensure_team_member, only: %i[dashboard details]
  before_action :ensure_captain, only: %i[ignore_joins watch_joins promote kick destroy
                                          accept_join_request deny_join_request]

  def ignore_joins
    @team.ignorejoins = true
    @team.save
    redirect_to details_team_path(@team)
  end

  def watch_joins
    @team.ignorejoins = false
    @team.save
    redirect_to details_team_path(@team)
  end

  def scoreboard
    @page_title = "Scoreboard"
    @teams = Team.all

    @teams = @teams.sort { |a, b| b.total_score <=> a.total_score }
    @teams = @teams.paginate(page: params[:page], :per_page => APP_CONFIG['page_size'])
  end

  # GET /teams
  def index
    @page_title = 'List of Teams'
    @teams = Team.all

    @teams = @teams.sort { |a, b| a.name.downcase <=> b.name.downcase }
    @teams = @teams.paginate(page: params[:page], :per_page => APP_CONFIG['page_size'])
  end

  def select_join
    return redirect_to dashboard_team_path(current_user.team) if current_user.team.present?

    @page_title = 'Select a team to join'
    @teams = []
    @teams = Team.unfull

    @teams = @teams.sort { |a, b| a.name.downcase <=> b.name.downcase }
    @teams = @teams.paginate(page: params[:page], :per_page => APP_CONFIG['page_size'])
  end

  def promote
    user_id = params[:user_id]
    records = User.where(id: user_id)
    return redirect_to root_path unless records.present?

    @team.team_captain_id = user_id
    @team.save

    redirect_to details_team_path(@team)
  end

  def quit
    return redirect_to root_path if current_user.id == @team.team_captain_id

    current_user.team_id = nil
    current_user.save

    redirect_to root_path
  end

  def kick
    user_id = params[:user_id]

    records = User.where(id: user_id)
    records.each do |record|
      record.team_id = nil
      record.save
    end
    redirect_to details_team_path(@team)
  end

  def request_join
    return redirect_to root_path if current_user.team.present?
    if @team.present?
      request = Joinrequest.create(user_id: current_user.id, team_id: @team.id)
      request.save
    end
    redirect_to select_join_teams_path
  end

  def cancel_join_request
    if @team.present?
      request = Joinrequest.where(user_id: current_user.id, team_id: @team.id)
      request.destroy_all
    end
    redirect_to select_join_teams_path
  end

  def accept_join_request
    user_id = params['user_id']
    user_records = User.where(id: user_id)
    user = user_records.present? ? user_records.first : nil

    if @team.present? && user.present?
      requests = Joinrequest.where(user_id: user.id)
      requests.destroy_all

      user.team_id = @team.id
      user.save
    end
    redirect_to details_team_path(@team)
  end

  def deny_join_request
    user_id = params['user_id']
    user_records = User.where(id: user_id)
    user = user_records.present? ? user_records.first : nil

    if @team.present? && user.present?
      requests = Joinrequest.where(user_id: user.id, team_id: @team.id)
      requests.destroy_all
    end
    redirect_to details_team_path(@team)
  end

  def details
    @join_requests = Joinrequest.for_team(@team.id)
  end

  def dashboard
    @join_requests = Joinrequest.for_team(@team.id)

    @show_join_requests =
      @team.ignorejoins.blank? &&
      @team.captain.id == current_user.id &&
      @join_requests.present? &&
      @team.users.count < APP_CONFIG['max_teamsize']
  end

  # GET /teams/new
  def new
    @page_title = 'Create a Team'
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
    @page_title = 'Edit a Team'
  end

  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        current_user.team_id = @team.id
        current_user.save
        requests = Joinrequest.where(user_id: current_user.id)
        requests.destroy_all

        @team.assign_all_quests

        format.html { redirect_to root_path, notice: 'Team was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /teams/1
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to teams_path, notice: 'Team was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /teams/1
  def destroy
    @team.joinrequests.destroy_all
    @team.users.update_all(team_id: nil)
    @team.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  def export
    @records = Team.all
    @records = @records.sort { |a, b| a.name.downcase <=> b.name.downcase }

    respond_to do |format|
      format.html do
        redirect_to teams_path, notice: 'Only CSV format can be exported.'
      end
      format.csv do
        send_data Team.to_csv(@records),
          :type => 'text/csv; charset=iso-8859-1; header=present',
          :disposition => "attachment; filename=teams.csv"
      end
    end
  end

  private

  def set_team
    @team = Team.find(params[:id])
    true
  end

  def team_params
    params.require(:team).permit(:name, :team_captain_id)
  end

  def ensure_auth
    return redirect_to(root_path) unless current_user
    true
  end

  def ensure_captain
    return redirect_to root_path unless current_user.id == @team.team_captain_id || current_user.is_admin
    true
  end

  def ensure_team_member
    return true if current_user.is_admin
    return redirect_to root_path unless current_user.team.present?
    return redirect_to root_path unless current_user.team.id == @team.id
    true
  end
end
