class TournamentJob < ApplicationJob
  queue_as :default
  # after_perform { |job| job.arguments.first.set_next_schedule }

  def perform(arg)
    p arg * 5
  end

end
