class TimeKeepingWorker
      include Sidekiq::Worker
      sidekiq_options lock: :until_executed

      def perform(record, company_id)
            company = Company.find(company_id)
            pid_list = company.worker_pid_list || []
            list = pid_list + [self.jid]
            company.update(worker_pid_list: list.uniq)

            success = []
            failed = []

            record.each do |r|
                  is_exist = TimeKeeping.where(company_id: company_id, date: r["date"], biometric_no: r["biometric_no"]).any?
                  if !is_exist
                        success.push(r.merge!({company_id: company_id, record_type: 1}))
                  else
                        details = {error: "record already exist", record: r }.to_json
                        failed.push({emp_bio_no: r["biometric_no"], details: details.to_s, company_id: company_id})
                  end
            end

            TimeKeeping.create(success)
            FailedTimeKeeping.create(failed)

            new_pid_list = company.worker_pid_list - [self.jid]
            company.update(worker_pid_list: new_pid_list.uniq) rescue nil

            send_cable(company_id) rescue nil
      end

      private

      def send_cable(company_id)
            ActionCable.server.broadcast "time_keeping_#{company_id}", { reload_counts: true }
      end
end
