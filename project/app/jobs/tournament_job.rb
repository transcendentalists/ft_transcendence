class TournamentJob < ApplicationJob
  queue_as :default
  # after_perform { |job| job.arguments.first.set_next_schedule }

  def perform(tournament)
    @tournament = tournament
    @today_round = tournament.today_round

    if Time.zone.now.hour == 0
      self.operate_tournament
    else
      self.operate_match
    end
  end

  def this_round_matches
    @tournament.matches.where('DATE(start_time) = ?', Date.yesterday)
  end

  def this_round_scorecards
    Scorecard.where(match_id: self.this_round_matches)
  end

  def update_membership_result
    if @today_round == 4
      @tournament.update_progress_memberships_result(result: "bronze")
    else
      match = self.this_round_matches.first
      if match.status == "completed"
        @tournament.memberships.find(user_id: match.winner.id).update(result: "gold")
        @tournament.memberships.find(user_id: match.loser.id).update(result: "silver")
      else
        @tournament.update_progress_memberships_result(result: "silver")
      end
    end
  end

  def update_membership_status
    if @today_round == 2
      @tournament.update_progress_memberships_status("completed")
    else
      match_ids = self.this_round_matches.where.not(status: "completed").ids
      user_ids = self.this_round_scorecards.where(match_id: match_ids).pluck("user_id")
      @tournament.memberships.where(user_id: user_ids).update_all(status: "completed")
    end
  end

  # match & scorecards column update 필요
  def operate_this_round_matches
    self.update_mebership_result if @today_round <= 4
    self.update_membership_status
    self.this_round_matches.each do |match|
      cards = match.scorecards
      case match.status
      when "pending"
      when "progress"
      when "canceled"
      when "completed"
      end
    end
  end

  def opreate_next_round_matches
  end

  def operate_tournament
    if Date.today == @tournament.start_date.to_date
      @tournament.start
      return if @tournament.canceled?
    else
      self.operate_this_round_matches
    end

    if @tournament.memberships.where(status: "progress").exists?
      self.opreate_next_round_matches
    else
      @tournament.complete
    end
  end

  def operate_match
  end
end
