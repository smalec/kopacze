class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_filter :valid_is_admin, except: [:show, :delete_from_team, :create, :destroy, :invitation]
  before_action :set_position_name

  respond_to :html

  def index
    @teams = Team.all.paginate(:page => params[:page], :per_page => 20)
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

    assign_league
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

    def assign_league
      if @team.league == nil
        town = @team.town
        lowest_div = town.leagues.sort_by{:division}[-1]
        if lowest_div == nil
          teams_in_town = Team.where(:town => @team.town, :league_id => nil)
          if teams_in_town.count > 5
            create_league(-1, 0, teams_in_town)
          end
        else
          lowest_div = lowest_div[:division]
          lowest_group = town.leagues.select{|league| league.division == lowest_div}.count
          lowest_league = League.where(:town => @team.town, :division => lowest_div, :group => lowest_group)[0]
          if lowest_league.teams.count < 12
            @team.league = lowest_league
            @team.save
          else
            teams_in_town = Team.where(:town => @team.town, :league_id => nil)
            if teams_in_town.count > 5
              create_league(lowest_div, lowest_group, teams_in_town)
            end
          end
        end
      end
    end

    def create_league(lowest_div, lowest_group, teams_in_town)
      league = League.new
      league.town = @team.town
      if lowest_div == -1
        league.division = 0
        league.group = 1
      elsif lowest_div == 0
        league.division = 1
        league.group = 1
      else
        if lowest_group == 2**(lowest_div - 1)
          league.division = lowest_div + 1
          league.group = 1
        else
          league.division = lowest_div
          league.group = lowest_group + 1
        end
      end
      league.teams << teams_in_town
      league.save
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
