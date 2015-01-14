class TownsController < ApplicationController
  before_action :set_town, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_filter :valid_is_admin, except: [:show]

  respond_to :html

  def index
    @towns = Town.all
    respond_with(@towns)
  end

  def show
    respond_with(@town)
  end

  def new
    @town = Town.new
    respond_with(@town)
  end

  def edit
  end

  def create
    @town = Town.new(town_params)
    @town.save
    respond_with(@town)
  end

  def update
    @town.update(town_params)
    respond_with(@town)
  end

  def destroy
    @town.destroy
    respond_with(@town)
  end

  private
    def set_town
      @town = Town.find(params[:id])
    end

    def town_params
      params.require(:town).permit(:name)
    end

    def valid_is_admin
      if current_user.is_admin == false
        redirect_to root_path, alert: 'Nie posiadasz uprawnień administratora'
      end
    end
end
