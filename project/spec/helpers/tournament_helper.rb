module TournamentHelper
  def create_tournament(options = {})
    options = {max: 8, register: 0}.merge(options)
    tournament = create(:tournament, max_user_count: options[:max])
    users = create_list(:user, options[:register])
    users.each { |user| TournamentMembership.create(user_id: user.id, tournament_id: tournament.id) }
    [tournament, users]
  end

  def start_tournament(tournament)
    TournamentJob.perform_now(tournament, {now: tournament.start_date.change(minute: 5)})
  end

  def all_tournament_membership_status(tournament)
    tournament.memberships.pluck("status")
  end

end
