class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_position_name
  before_action :authenticate_user!
  before_filter :valid_is_admin, except: [:show]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/1/edit
  def edit
    @towns = Town.all
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Zaktualizowano użytkownika.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user.id == current_user.id
      respond_to do |format|
        format.html { redirect_to users_url, alert: 'Nie możesz usunąć samego siebie.' }
        format.json { render :show, status: :ok, location: @user }
      end
    else
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'Usunięto użytkownika.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def set_position_name
      @position_name = {'gk'  => 'Bramkarz',
                        'def' => 'Obrońca',
                        'mid' => 'Pomocnik',
                        'for' => 'Napastnik'}
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :surname, :position, :email, :town_id, :is_admin)
    end

    def valid_is_admin
      if current_user.is_admin == false
        redirect_to root_path, alert: 'Nie posiadasz uprawnień administratora'
      end
    end
end
