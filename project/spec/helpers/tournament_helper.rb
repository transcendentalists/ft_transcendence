module TournamentHelper
  def create_tournament(options = { register: 8 })
    max_user_count = [8,16,32].find { |count| count >= options[:register] } 
    @tournament = create(:tournament, max_user_count: max_user_count)
    @users = create_list(:user, options[:register])
    @users.each { |user| TournamentMembership.create(user_id: user.id, tournament_id: @tournament.id) }
    [@tournament, @users]
    self.print_tournament
    self.print_memberships
  end

  def start_tournament
    TournamentJob.perform_now(@tournament, {now: @tournament.start_date.midnight.change(min: 5)})
    self.print_day 1
    self.print_tournament
    self.print_memberships
    self.print_matches
  end

  def operate_tournament(options = { day: 1 } )
    return start_tournament(@tournament) if options[:day] == 1
    day_after = (options[:day] - 1).day
    TournamentJob.perform_now(@tournament, {now: (@tournament.start_date + day_after).midnight.change(min: 5)})
    self.print_day options[:day]
    self.print_memberships
    self.print_matches
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
    @tournament.matches.where(status: "pending").each do |match|
      if rand(100) <= (options[:complete_ratio] * 100 - 1)
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
    
    @file.puts if @file
    self.print_tournament 
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

  def matches_count_if_all_completed_when(user_count)
    cache = {0 => 0, 1 => 0, 2 => 1, 3 => 2, 4 => 3, 5 => 4, 6 => 5, 7 => 6, 8 => 7}
    return cache[user_count] if !cache[user_count].nil?
    matches_count = 0
    while user_count > 8
      matches_count += user_count / 2
      user_count -= user_count / 2
    end
    matches_count + cache[user_count]
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

  def bronze_count_if_all_match_completed_when(user_count)
    [8,*(13..16),*(25..32)].include?(user_count) ? 2 : 1
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

  def expect_same_gold_and_silver_count
    gold_count = self.memberships_count({result: "gold"})
    expect([0,1].include?(gold_count)).to eq(true)
    expect(gold_count).to eq(self.memberships_count({result: "silver"}))
  end

  def expect_normal_memberships_result_count
    gold_count = self.memberships_count({result: "gold"})
    expect([0,1].include?(gold_count)).to eq(true)
    silver_count = self.memberships_count({result: "silver"})
    expect([0,1,2].include?(silver_count) && (gold_count + silver_count <= 2)).to eq(true)
    count = gold_count + silver_count
    expect(4 - count >= self.memberships_count({result: "bronze"})).to eq(true)
  end

  def print_to(file_name)
    @file = File.open("spec/log/#{file_name}", 'w')
  end

  def print_close
    @file.close
  end

  def print_day(day)
    return if @file.nil?
    @file.puts "\n\n"
    @file.puts "! #{day.to_s} DAY OPERATION EXECUTE !".center(55)
    @file.puts "\n\n"
  end

  def print_tournament
    return if @file.nil?
    column = "max".ljust(5) + "rule".ljust(8) + "status".ljust(10) \
    + "start_date".ljust(15) + "match_time".ljust(15) + "prize"
    t = @tournament
    value = t.max_user_count.to_s.ljust(5) + t.rule_id.to_s.ljust(8) + t.status.ljust(10) \
    + t.start_date.strftime("%Y/%m/%d").ljust(15) + t.tournament_time.strftime("%H:%M").ljust(15) \
    + t.incentive_title

    @file.puts ("<#{@tournament.title.upcase}> TOURNAMENT").center(55)
    @file.puts column
    @file.puts value
    @file.puts
  end

  def print_matches
    return if @file.nil?
    @file.puts
    @file.puts "> MATCHES LIST <".center(55)
    @file.puts "id".ljust(6) + "rule".ljust(6) + "time".ljust(20) + "status".ljust(15) \
    + "score".ljust(20) + "left_user".ljust(24) + "right_user".ljust(24)
    t = @tournament
    t.reload.matches.order(id: :asc).each do |m|
      @file.puts m.id.to_s.ljust(6) + m.rule_id.to_s.ljust(6) + m.start_time.strftime("%Y/%m/%d %H:%M").ljust(20) \
      + m.status.ljust(15) \
      + (m.scorecards.find_by_user_id(m.users.first.id).result.to_s \
      + ":" + m.scorecards.find_by_user_id(m.users.second.id).result.to_s).ljust(20) \
      + m.users.first.name.ljust(24) + m.users.second.name.ljust(24)
    end
  end

  def print_memberships
    return if @file.nil?
    @file.puts "> REGISTERED MEMBERSHIPS PROFILE <".center(55)
    @file.puts "id".ljust(6) + "title".ljust(10) + "status".ljust(12) + "result".ljust(10) + "name"
    t = @tournament
    t.reload.memberships.order(id: :asc).each do |m|
      @file.puts m.user_id.to_s.ljust(6) + m.user.title.ljust(10) + m.status.ljust(12) + m.result.ljust(10) + m.user.name
    end
  end

end
