class TimeKeepingWorker
      include Sidekiq::Worker
      sidekiq_options lock: :until_executed

      def perform(record, company_id)
            company = Company.find(company_id)
            jid_list = company.worker_pid_list
            company.update(worker_pid_list: company.worker_pid_list + [self.jid]) if !jid_list.include?(self.jid)
            failed = []
            record.each do |r|
                  rec = TimeKeeping.new(r.merge!({company_id: company_id, record_type: 1}))
                  unless rec.save
                        details = { errors: rec.errors, record: r }.to_json
                        failed.push({emp_bio_no: r["biometric_no"], details: details.to_s, company_id: company_id})
                  end
            end
            FailedTimeKeeping.create(failed)
            pid_list = company.worker_pid_list - [self.jid]
            company.update(worker_pid_list: pid_list) rescue nil
            send_cable(company_id) rescue nil
      end

      private

      def send_cable(company_id)
            ActionCable.server.broadcast "time_keeping_#{company_id}", { reload_counts: true }
      end
end
