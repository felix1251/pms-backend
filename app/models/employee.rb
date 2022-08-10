class Employee < ApplicationRecord
      belongs_to :company
      belongs_to :department
      belongs_to :salary_mode
      before_create :add_custom_column_data
      before_update :add_custom_column_data
      
      secret_key = Rails.application.credentials[:DB_COL_ENCRYPTED_KEY]
      secret_key =  [secret_key].pack("H*")
      attr_encrypted :compensation, :key => secret_key, :mode => :per_attribute_iv_and_salt

      validates :compensation, numericality: { only_integer: true }
      validates :biometric_no, uniqueness: { scope: :company_id }
      validates :email, allow_blank: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP , :message => "email format is invalid"}

      def attributes
            # don't show this encrypted_columns 
            super.except('encrypted_compensation', 'encrypted_compensation_salt', 'encrypted_compensation_iv')
      end

      private

      def add_custom_column_data
            self.employee_id = generate_emp_id
            self.first_name = self.first_name.upcase
            self.last_name = self.last_name.upcase
            self.middle_name = self.middle_name.upcase
            self.suffix = self.suffix.upcase
            self.job_classification = self.job_classification.upcase
            self.position = self.position.upcase
            self.assigned_area = self.assigned_area.upcase
            self.employment_status = self.employment_status.upcase
      end

      def generate_emp_id
            f_init = self.first_name[0, 1].capitalize()
            l_init = self.last_name[0, 1].capitalize()
            m_init = self.middle_name[0, 1].capitalize()
            s_init = self.suffix.upcase || ""
            final_init = l_init + f_init + m_init + s_init
            final_init = final_init.upcase
            loop do
                  id = "#{self.company.code.upcase}-#{final_init}-#{SecureRandom.hex(3).upcase}"
                  break id unless Employee.where(company_id: self.company.id, employee_id: id).exists?
            end
      end
end
