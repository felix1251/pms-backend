class EmployeeWorker
  include Sidekiq::Worker

  def perform(sample)
    puts "run #{sample}"
    # Do something
  end
end
