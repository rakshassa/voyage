class TeamsController < ApplicationController
  before_action :set_team, only: %i[edit update destroy dashboard join kick]
  before_action :ensure_auth

  # GET /teams
  def index
    @page_title = 'List of Teams'
    @teams = []
    @teams = Team.all

    @teams = @teams.sort { |a, b| a.name.downcase <=> b.name.downcase }
    @teams = @teams.paginate(page: params[:page], :per_page => 20)
  end

  def select_join
    @page_title = 'Select a team to join'
    @teams = []
    @teams = Team.unfull

    @teams = @teams.sort { |a, b| a.name.downcase <=> b.name.downcase }
    @teams = @teams.paginate(page: params[:page], :per_page => 20)
  end

  def kick
    return redirect_to root_path unless current_user.id == @team.team_captain_id
    user_id = params[:user_id]

    records = User.where(id: user_id)
    records.each do |record|
      record.team_id = nil
      record.save
    end
    redirect_to root_path
  end

  def join
    respond_to do |format|
      if @team.present?
        current_user.team_id = @team.id
        current_user.save
        format.html { redirect_to dashboard_team_path(@team), notice: 'Team was successfully joined.' }
      else
        format.html { render :select_join, notice: 'Please choose a team.' }
      end
    end
  end

  def dashboard
    return redirect_to root_path if current_user.team_id != @team.id
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
    @team.destroy

    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Tean was successfully deleted.' }
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

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
    true
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params.require(:team).permit(:name, :team_captain_id)
  end

  def ensure_auth
    redirect_to(root_path) && return unless current_user
    true
  end
end
