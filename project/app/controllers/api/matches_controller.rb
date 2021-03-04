class Api::MatchesController < ApplicationController
  def index
    if params[:user_id]
      match_history_list = Match.for_user_index(params[:user_id])
      render json: { matches: match_history_list }
    elsif params[:war_id]
      render plain: 'This is war ' + params[:war_id] + "'s matches"
    else
      render plain: 'get /api/matches/index'
    end
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      match = find_or_create_match(user)
      render json: {
               match: {
                 id: match.id,
                 match_type: params[:match_type],
                 user: {
                   id: user.id,
                 },
               },
             }
    elsif params[:war_id]
      render plain: 'war creates ' + params[:war_id] + "'s matches"
    else
      render plain: 'post /api/matches/create'
    end
  end

  def join
    if params[:id]
      render plain: 'You just joined ' + params[:id] + ' match'
    else
      render plain:
               'The war id is ' + params[:war_id] + ' and the match is ' +
                 params[:match_id]
    end
  end

  def report
    render plain: 'You just finished ' + params[:id] + ' match'
  end

  private

  def find_or_create_match(user)
    if ["ladder", "casual_ladder"].include?(params[:match_type])
      match = find_or_create_ladder_match_for(user, { type: params[:match_type]} )
    elsif params[:match_type] == 'dual'
      match =
        if params[:match_id].nil?
          create_dual_match_for(user, params[:rule_id], params[:target_score])
        else
          join_dual_match_for(user, params[:match_id])
        end
    end
    match
  end

  def find_or_create_ladder_match_for(user, options = {type: "casual_ladder"} )
    # 거르는 이유: 중복참여 방지. 게임 중인데 또 게임하는 것 방지하기 위함.
    return nil if user.playing?
    # return nil unless Scorecard.where(user_id: user.id, result: ["wait", "ready"]).first.nil?
    ActiveRecord::Base.transaction do
      @match = Match.where(match_type: options[:type], status: "pending").last
      @match = Match.create(match_type: options[:type], rule_id: 1) if @match.nil?
      @match.with_lock do
        user_count = Scorecard.where(match_id: @match.id).count
        if user_count >= 2
          @match = Match.create(match_type: options[:type], rule_id: 1)
        end
        side = @match.users.count == 0 ? "left" : "right"
        card = Scorecard.create(user_id: user.id, match_id: @match.id, side: side)
        user.update_status("playing")
      end
    end
    @match
  end

  def create_dual_match_for(user, rule_id, target_score)
    match =
      Match.create(
        match_type: 'dual',
        status: 'pending',
        rule_id: rule_id,
        target_score: target_score,
      )
    card = Scorecard.create(user_id: user.id, match_id: match.id, side: 'left')
    user.update_status('playing')
    match
  end

  def join_dual_match_for(user, match_id)
    match = Match.find(match_id)
    card = Scorecard.create(user_id: user.id, match_id: match_id, side: 'right')
    user.update_status('playing')
    match
  end
end
