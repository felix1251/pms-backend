class TimeKeepingWorker
      include Sidekiq::Worker
      sidekiq_options lock: :until_executed

      def perform(record, company_id)
            company = Company.find(company_id)
            record.each do |r|
                  rec = TimeKeeping.new(r.merge!({company_id: company_id, record_type: 1}))
                  unless rec.save
                        details = { errors: rec.errors, record: r }.to_json
                        FailedTimeKeeping.create({emp_bio_no: r["biometric_no"], details: details.to_s, company_id: company_id})
                  end
                  count = company.pending_time_keeping - 1
                  unless count < 0
                        company.update(pending_time_keeping: count)
                  end
            end
            send_cable(company_id)
            puts "time keeping worker success"
      end

      def send_cable(company_id)
            sql = "SELECT"
            sql += " com.pending_time_keeping AS pending,"
            sql += " (SELECT COUNT(*) FROM time_keepings AS tk WHERE tk.company_id = com.id) AS succeeded,"
            sql += " (SELECT COUNT(*) FROM failed_time_keepings AS ftk WHERE ftk.company_id = com.id) AS rejected"
            sql += " FROM companies AS com"
            sql += " WHERE id = #{company_id} LIMIT 1"
            counts = ActiveRecord::Base.connection.exec_query(sql).first
            ActionCable.server.broadcast "time_keeping_#{company_id}", counts.merge!({proccesed: counts["succeeded"] + counts["rejected"]})
      end
end
