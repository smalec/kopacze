class LeaguesController < ApplicationController
  before_action :set_league, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_filter :valid_is_admin, except: [:show]

  respond_to :html

  def index
    @leagues = League.all
    respond_with(@leagues)
  end

  def show
    respond_with(@league)
  end

  def new
    @league = League.new
    @towns  = Town.all
    respond_with(@league)
  end

  def edit
    @towns = Town.all
  end

  def create
    @league = League.new(league_params)

    @towns = Town.all
    town = @league.town
    lowest_div = town.leagues.sort_by{:division}[-1]
    if lowest_div == nil
      @league.division = 0
      @league.group = 1
    else
      lowest_div = lowest_div[:division]
      if lowest_div == 0
        @league.division = 1
        @league.group = 1
      elsif lowest_div == 1
        @league.division = 2
        @league.group = 1
      else
        groups_in_lowest_div = town.leagues.select{|league| league.division == lowest_div}.count
        if groups_in_lowest_div == 2**(lowest_div - 1)
          @league.division = lowest_div + 1
          @league.group = 1
        else
          @league.division = lowest_div
          @league.group = groups_in_lowest_div + 1
        end
      end
    end

    @league.save
    respond_with(@league)
  end

  def update
    @towns = Town.all
    @league.update(league_params)
    respond_with(@league)
  end

  def destroy
    @league.destroy
    respond_with(@league)
  end

  private
    def set_league
      @league = League.find(params[:id])
    end

    def league_params
      params.require(:league).permit(:division, :group, :town_id)
    end

    def valid_is_admin
      if current_user.is_admin == false
        redirect_to root_path, alert: 'Nie posiadasz uprawnień administratora'
      end
    end
end
