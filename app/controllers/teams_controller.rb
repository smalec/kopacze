class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_filter :valid_is_admin, except: [:show, :delete_from_team, :create, :destroy]
  before_action :set_position_name

  respond_to :html

  def index
    @teams = Team.all
    respond_with(@teams)
  end

  def show
    respond_with(@team)
  end

  def new
    @team = Team.new
    @leagues = League.all
    @players = @captains = User.where(:team_id => nil)
    respond_with(@team)
  end

  def edit
    @leagues = League.all
    @players = User.where(:team_id => nil, :town => @team.town)
    @captains = @players + @team.players
  end

  def create
    @leagues = League.all
    @players = @captains = User.where(:team_id => nil)
    @team = Team.new(team_params)
    @team.players << @team.captain
    @team.town = @team.captain.town
    @team.save
    if params[:team][:players] != nil
      for player_id in params[:team][:players][1..-1]
        User.update(player_id, :team_id => @team.id)
      end
    end
    respond_with(@team)
  end

  def delete_from_team
    User.update(params[:player_id], :team_id => nil)
    redirect_to team_path(params[:team]), notice: 'Pomyślnie usunięto zawodnika z drużyny'
  end

  def update
    @leagues = League.all
    @players = User.where(:team_id => nil, :town => @team.town)
    @captains = @players + @team.players
    @team.update(team_params)
    for player_id in params[:team][:players][1..-1]
      User.update(player_id, :team_id => @team.id)
    end
    respond_with(@team)
  end

  def destroy
    @team.destroy
    if current_user.is_admin
      respond_with(@team)
    else
      redirect_to root_path, notice: 'Pomyślnie rozwiązano drużynę'
    end
  end

  private
    def set_position_name
      @position_name = {'gk'  => 'Bramkarz',
                        'def' => 'Obrońca',
                        'mid' => 'Pomocnik',
                        'for' => 'Napastnik'}
    end

    def set_team
      @team = Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit(:name, :league_id, :captain_id, :town_id)
    end

    def valid_is_admin
      if current_user.is_admin == false
        redirect_to root_path, alert: 'Nie posiadasz uprawnień administratora'
      end
    end
end
