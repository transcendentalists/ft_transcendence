class HardWorker
  include Sidekiq::Worker

  def perform(name, count)
    p name * count
  end
end

HardWorker.perform_at(10.seconds.from_now, 'eunhkim', 5)
