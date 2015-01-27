class HomeController < ApplicationController
  def index
    if user_signed_in? and current_user.team == nil
      @team = Team.new
    end
    render :layout => 'application'
  end

  def search
    results = []
    if params[:search]
      category_hash = {'1' => [Team], '2' => [User], '3'  => [Town], '4' => [Team, User, Town]}
      category_hash[params[:category]].each do |table|
        results += table.where('name LIKE ?', "%#{params[:search]}%")
        if table == User
          table.where('surname LIKE ?', "%#{params[:search]}%").each do |user|
            results.push(user) unless results.include?(user)
          end
        end
      end
    end
    @results_left   = results.select{|result| results.index(result) % 3 == 0}
    @results_center = results.select{|result| results.index(result) % 3 == 1}
    @results_right  = results.select{|result| results.index(result) % 3 == 2}

    @categories = [{id: 1, name: 'Drużyna'}, {id: 2, name: 'Gracz'}, {id: 3, name: 'Miasto'}, {id: 4, name: 'Wszystko'}]
  end

  def rules
  end

  def about
  end

  def contact
  end
end
