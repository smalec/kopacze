class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_filter :valid_is_admin, except: [:show, :new, :team_matches, :create_invitation, :destroy_invitation]

  respond_to :html

  def index
    @matches = Match.all
    respond_with(@match)
  end

  def show
    @rows = @match.home_score > @match.visitor_score ? @match.home_score : @match.visitor_score
    respond_with(@match)
  end

  def team_matches
    @played = current_user.team.home_matches + current_user.team.visitor_matches
    @played.sort!{|match| match.date}.reverse

    @upcoming = MatchInvitation.where(:sender_id => current_user.team.id, :accepted => true)
    @upcoming += MatchInvitation.where(:receiver_id => current_user.team.id, :accepted => true)
    @upcoming.sort!{|invitation| invitation.date}

    @received_unread = current_user.team.received_match_invitations.select{|inv| inv.read == false}
    @received = current_user.team.received_match_invitations.select{|inv| inv.read}

    @sent = current_user.team.send_match_invitations

    for unread in @received_unread
      unread.read = true
      unread.save
    end
  end

  def add_scorers
    @home = params[:home].to_i
    @score = params[:score].to_i
    if params[:match_id]
      @match = Match.find(params[:match_id])
    end
    @players = User.where(:team_id => params[:team])
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create_invitation
    @invitation = MatchInvitation.new(invitation_params)
    @invitation.save
    redirect_to :back, notice: 'Pomyślnie wysłano propozycję spotkania.'
  end

  def destroy_invitation
    invitation = MatchInvitation.find(params[:id])
    if params[:accept] == '1'
      invitation.accepted = true
      invitation.save
    else
      invitation.destroy
    end
    redirect_to :back
  end

  def new
    @match = Match.new
    if current_user.is_admin
      @homes = @visitors = Team.all
    else
      @homes = Team.where(:id => current_user.team.id)
      @visitors = Team.where(:league_id => current_user.team.league.id)
      @visitors.delete(@homes[0])
    end
    respond_with(@match)
  end

  def edit
    @homes = @visitors = Team.all
  end

  def create
    @match = Match.new(match_params)
    set_dependencies

    @match.save
    respond_with(@match)
  end

  def update
    delete_dependencies
    @match.destroy

    @match = Match.new(match_params)
    set_dependencies

    @match.save
    respond_with(@match)
  end

  def destroy
    delete_dependencies

    @match.destroy
    respond_with(@match)
  end

  private
  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:home_id, :visitor_id, :league_id, :visitor_score, :home_score, :date)
    end

  def invitation_params
    params.permit(:sender_id, :receiver_id, :date, :place)
  end

  def valid_is_admin
    if current_user.is_admin == false
      redirect_to root_path, alert: 'Nie posiadasz uprawnień administratora.'
    end
  end

  def delete_dependencies
    @match.home.scored -= @match.home_score
    @match.home.lost -= @match.visitor_score
    @match.visitor.scored -= @match.visitor_score
    @match.visitor.lost -= @match.home_score
    if @match.home_score > @match.visitor_score
      @match.home.points -= 3
    elsif @match.home_score == @match.visitor_score
      @match.home.points -= 1
      @match.visitor.points -= 1
    else
      @match.visitor.points -= 3
    end
    @match.home.save
    @match.visitor.save

    @match.home_scorers.each do |id|
      scorer = User.find(id)
      scorer.goals -= 1
      scorer.save
    end
    @match.visitor_scorers.each do |id|
      scorer = User.find(id)
      scorer.goals -= 1
      scorer.save
    end
  end

  def set_dependencies
    @match.league_id = @match.home.league.id
    @match.home.scored += @match.home_score
    @match.home.lost += @match.visitor_score
    @match.visitor.scored += @match.visitor_score
    @match.visitor.lost += @match.home_score
    if @match.home_score > @match.visitor_score
      @match.home.points += 3
    elsif @match.home_score == @match.visitor_score
      @match.home.points += 1
      @match.visitor.points += 1
    else
      @match.visitor.points += 3
    end
    @match.home.save
    @match.visitor.save

    params[:home_scorers].each do |home_scorer|
      scorer = User.find(home_scorer[1])
      @match.home_scorers += [scorer.id]
      scorer.goals += 1
      scorer.save
    end
    params[:visitor_scorers].each do |visitor_scorer|
      scorer = User.find(visitor_scorer[1])
      @match.visitor_scorers += [scorer.id]
      scorer.goals += 1
      scorer.save
    end
  end
end
