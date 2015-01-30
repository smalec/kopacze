class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:search]
  require 'will_paginate/array'

  def index
    @last_users = User.last(3)
    @last_teams = Team.last(3)
    @last_matches = Match.last(3)
    if user_signed_in? and current_user.team == nil
      @team = Team.new
    end
    render :layout => 'application'
  end

  def search
    @results = User.none
    if params[:search]
      category_hash = {'1' => [Team], '2' => [User], '3'  => [Town], '4' => [Team, User, Town]}
      category_hash[params[:category]].each do |table|
        if table == User
          if params[:position] == '1'
            @results += table.where('name LIKE ? OR surname LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
          else
            @results += table.where('(name LIKE ? OR surname LIKE ?) AND position = ?', "%#{params[:search]}%",
                                                                      "%#{params[:search]}%", params[:position].to_i - 2)
          end
          if params[:free]
            @results.select!{|res| res.team == nil}
          end
        else
          @results += table.where('name LIKE ?', "%#{params[:search]}%")
        end
      end
    end
    @results = @results.paginate(:page => params[:page], :per_page => 12)
    @results_left   = @results.select{|result| @results.index(result) % 3 == 0}
    @results_center = @results.select{|result| @results.index(result) % 3 == 1}
    @results_right  = @results.select{|result| @results.index(result) % 3 == 2}

    @categories = [{id: 1, name: 'Drużyna'}, {id: 2, name: 'Gracz'}, {id: 3, name: 'Miasto'}, {id: 4, name: 'Wszystko'}]
    @positions = [{id: 1, name: 'Dowolna pozycja'}, {id: 2, name: 'Bramkarz'}, {id: 3, name: 'Obrońca'},
                  {id: 4, name: 'Pomocnik'}, {id: 5, name: 'Napastnik'}]
  end

  def rules
  end

  def about
  end

  def contact
  end
end
