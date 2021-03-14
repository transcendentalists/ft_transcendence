class TournamentJob < ApplicationJob
  queue_as :default
  after_perform { |job| job.arguments.first.set_next_schedule }

  def perform(tournament, options = { now: Time.zone.now })
    begin
      @tournament = tournament
      @today_round = tournament.today_round
      @now = options[:now]
  
      # 자정이면, 경기 결산 및 신규 경기 생성 등 토너먼트 운영 
      # 자정이 아니라면, 경기 운영(경기 시작/취소)
      ActiveRedord::Base.transaction do
        if @now.hour == 0
          self.operate_tournament!
        else
          self.operate_match!
        end
      end
    rescue => e
      put "[ERROR][TournamentJob_#{@tournament.id}] #{e.message}"
  end

  def operate_tournament!
    if @tournament.first_date?(@now)
      @tournament.start!
      return if @tournament.canceled?
    else
      self.operate_this_round_matches!
    end

    if @tournament.progress_memberships.count > 1
      self.opreate_next_round_matches!
    else
      @tournament.complete!
    end
  end

  def operate_this_round_matches!
    self.cancel_exceptional_match!
    self.update_membership_result! if @today_round <= 4
    self.update_membership_status!
  end

  def this_round_matches
    this_round_day = @now.yesterday.change(hour: @tournament.tournament_time.hour).utc.to_date
    @tournament.matches.where('DATE(start_time) = ?', this_round_day)
  end

  def this_round_scorecards
    Scorecard.where(match_id: self.this_round_matches.ids)
  end

  def cancel_exceptional_match!
    self.this_round_matches.where(status: ["progress", "pending"]).each do |match|
      match.update!(status: "canceled")
      match.scorecards.update_all(result: "canceled")
    end
  end

  def update_membership_result!
    if @today_round == 4
      @tournament.update_progress_memberships!(result: "bronze")
    else
      # 결승전
      match = @tournament.last_match
      if match.completed?
        @tournament.memberships.find_by_user_id(match.winner.id).update!(result: "gold")
        @tournament.memberships.find_by_user_id(match.loser.id).update!(result: "silver")
      else
        @tournament.update_progress_memberships!(result: "silver")
      end
    end
  end

  def update_membership_status!
    if @today_round == 2
      @tournament.update_progress_memberships!(status: "completed")
    else
      user_ids = self.this_round_scorecards.where.not(result: "win").pluck("user_id")
      @tournament.memberships.where(user_id: user_ids).update_all(status: "completed")
    end
  end

  def opreate_next_round_matches!
    membership_ids = @tournament.progress_memberships.ids
    membership_ids.shuffle!
    while membership_ids.count > 1 do
      pair = membership_ids.pop(2)
      self.create_match!(*pair)
    end
  end

  def create_match!(left_membership_id, right_membership_id)
    match = Match.create!({
      rule_id: @tournament.rule_id,
      eventable_type: "Tournament",
      eventable_id: @tournament.id,
      match_type: "tournament",
      start_time: @now.change(hour: @tournament.tournament_time.hour),
      target_score: @tournament.target_match_score,
    })
    card_entry = {'left': left_membership_id, 'right': right_membership_id}
    card_entry.each do |side, membership_id|
      Scorecard.create!(
        user_id: TournamentMembership.find(membership_id).user.id,
        match_id: match.id,
        side: side
      )
    end
  end

  def operate_match!
    @tournament.matches.where(status: "pending").each { |match| match.start! }
  end
end
