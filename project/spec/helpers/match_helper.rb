module MatchHelper

  def create_match(options = {eventable_type: "War",
      eventable_id: 1,
      match_type: "war",
      left_user: nil,
      right_user: nil})

    eventable_id = options[:eventable_id]
    left_user = options[:left_user]
    right_user = options[:right_user]
    raise "user가 입력되지 않았습니다." if left_user.nil? || right_user.nil?

    @match = create(:match, eventable_id: eventable_id, match_type: options[:match_type])

    @left_scorecard = create(:scorecard,
                            user_id: left_user.id,
                            match_id: @match.id,
                            side: "left")

    @right_scorecard = create(:scorecard,
                            user_id: right_user.id,
                            match_id: @match.id,
                            side: "right")
    @match
  end

  def let_challenger_win(match)
    match.scorecards.find_by_side("left").update(score: match.target_score)
    match.scorecards.find_by_side("right").update(score: 0)
    complete_by_match_end(match)
  end

  def complete_by_match_end(match)
    match.scorecards.each do |card|
      card.update(result: card.score == @match.target_score ? "win" : "lose")
    end
    match.complete({type: "END"})
  end

end
