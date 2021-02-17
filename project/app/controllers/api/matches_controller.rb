class Api::MatchesController < ApplicationController
  def index
    if params[:user_id]
      match_history_list = Match.for_user_index(params[:user_id])
      render :json => {
        matches: match_history_list
      }
    elsif params[:war_id]
      render plain: "This is war " + params[:war_id] + "'s matches"
    else
      render plain: "get /api/matches/index"
    end
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      match = find_or_create_ladder_match_for(user)
      return render_error("MATCH EXISTS", "유저의 완료되지 않은 매치가 있습니다.", 400) if match.nil?
      render :json => { match: { id: match.id, match_type: 'ladder', user: { id: user.id } } }
    elsif params[:war_id]
      render plain: "war creates " + params[:war_id] + "'s matches"
    else
      render plain: "post /api/matches/create"
    end
  end

  def join
    if params[:id]
      render plain: "You just joined " + params[:id] + " match"
    else
      render plain: "The war id is " + params[:war_id] + " and the match is " + params[:match_id]
    end
  end

  def report
    render plain: "You just finished " + params[:id] + " match"
  end

  private
  def find_or_create_ladder_match_for(user)
    return nil unless Scorecard.where(user_id: user.id, result: ["wait", "ready"]).first.nil?
    ActiveRecord::Base.transaction do
      @match = Match.where(match_type: "ladder", status: "pending").last
      @match = Match.create(match_type: "ladder", rule_id: 1) if @match.nil?
      @match.with_lock do
        user_count = Scorecard.where(match_id: @match.id).count
        if user_count >= 2
          @match = Match.create(match_type: "ladder", rule_id: 1)
        end
        side = @match.users.count == 0 ? "left" : "right"
        card = Scorecard.create(user_id: user.id, match_id: @match.id, side: side)
        user.update_status("playing")
      end
    end
    @match
  end

end
