class EmployeeActionHistoryWorker
  include Sidekiq::Worker
  sidekiq_options lock: :until_executed
  
  def perform(action_by_id, action_at, action_type, employee_id)
    EmployeeActionHistory.create(action_by_id: action_by_id, action_at: action_at,
                                employee_id: employee_id, action_type: action_type)
  end
end
