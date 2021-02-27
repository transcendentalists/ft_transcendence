module TournamentHelper
  def create_tournament(options = { register: 8 })
    max_user_count = [8,16,32].find { |count| count >= options[:register] } 
    @tournament = create(:tournament, max_user_count: max_user_count)
    @users = create_list(:user, options[:register])
    @users.each { |user| TournamentMembership.create(user_id: user.id, tournament_id: @tournament.id) }
    [@tournament, @users]
  end

  def start_tournament
    TournamentJob.perform_now(@tournament, {now: @tournament.start_date.midnight.change(min: 5)})
  end

  def operate_tournament(options = { day: 1 } )
    return start_tournament(@tournament) if options[:day] == 1
    day_after = (options[:day] - 1).day
    TournamentJob.perform_now(@tournament, {now: (@tournament.start_date + day_after).midnight.change(min: 5)})
  end

  def simulate_match(match)
    match.update(status: "completed")
    winner = match.users[rand(2)]
    match.scorecards.each do |card|
      if card.user_id == winner.id
        card.update(score: match.target_score, result: "win")
      else
        card.update(score: rand(match.target_score), result: "lose")
      end
    end
  end

  def simulate_matches(options = { complete_ratio: 1 })
    expect(options[:complete_ratio]).to be_within(0.1).of(1.0)
    @tournament.matches.where(status: "pending").each do |match|
      if rand(100) <= options[:complete_ratio] * 100
        simulate_match(match)
      else
        match.cancel
      end
    end
  end

  def simulate_tournament(options = { complete_ratio: [1.0] })
    self.start_tournament
    max_loop_count = 3 + [8, 16, 32].find_index(@tournament.today_round)
    max_loop_count.times do |count|
      break unless @tournament.progress?
      
      day = count + 2
      if count < options[:complete_ratio].length
        ratio = options[:complete_ratio][count]
      else
        ratio = options[:complete_ratio][options[:complete_ratio].length - 1]
      end
  
      self.simulate_matches({ complete_ratio: ratio })
      self.operate_tournament({ day: day })
    end 
  end

  def matches(options = {day: 1})
    date = (@tournament.first_match_datetime.utc + (options[:day] - 1).days).to_date
    @tournament.matches.where('DATE(start_time) = ?', date)
  end

  def scorecards(options = {day: 1})
    Scorecard.where(match_id: self.matches(@tournament, options).ids)
  end

  def all_memberships_count
    @tournament.memberships.count
  end

  def memberships_count(options = {})
    return self.all_memberships_count if options.empty?
    @tournament.memberships.where(options).count
  end

  def all_matches_count
    @tournament.matches.count
  end

  def matches_count(options = {})
    return self.all_matches_count if options.empty?
    @tournament.matches.where(options).count
  end

  def all_scorecards_count
    @tournament.scorecards.count
  end

  def scorecards_count(options = {})
    return self.all_scorecards_count if options.empty?
    @tournament.scorecards.where(options).count
  end

  def expect_all_memberships_count(count)
    expect(self.all_memberships_count).to eq(count)
  end

  def expect_memberships_count(count, options = {} )
    return self.expect_all_memberships_count if options.empty?
    expect(self.memberships_count(options)).to eq(count)
  end

  def expect_all_matches_count(count)
    expect(self.all_matches_count).to eq(count)
  end

  def expect_matches_count(count, options = {} )
    return self.expect_all_matches_count if options.empty?
    expect(self.matches_count(options)).to eq(count)
  end

  def expect_status(status)
    expect(@tournament.status).to eq(status)
  end

  def expect_all_scorecards_count(count)
    expect(self.all_scorecards_count).to eq(count)
  end

  def expect_scorecards_count(count, options = {})
    return self.expect_all_scorecards_count if options.empty?
    expect(self.scorecards_count(options)).to eq(count)
  end

  def expect_winner_get_title(expect_boolean)
    winner = @tournament.winner
    expect(!winner.nil? && winner.title == @tournament.incentive_title).to eq(expect_boolean)
  end
end
