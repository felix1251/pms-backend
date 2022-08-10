class Employee < ApplicationRecord
      belongs_to :company
      belongs_to :department
      belongs_to :salary_mode
      before_create :add_custom_column_data
      before_update :on_emp_update
      
      secret_key = Rails.application.credentials[:DB_COL_ENCRYPTED_KEY]
      secret_key =  [secret_key].pack("H*")
      attr_encrypted :compensation, :key => secret_key, :mode => :per_attribute_iv_and_salt

      validates :compensation, numericality: { only_integer: true }
      validates :biometric_no, uniqueness: { scope: :company_id }
      validates :email, allow_blank: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP , :message => "email format is invalid"}
      enum status: { A: "A", I: "I"}
      
      def attributes
            # don't show this encrypted_columns 
            super.except('encrypted_compensation', 'encrypted_compensation_salt', 'encrypted_compensation_iv')
      end

      private

      def add_custom_column_data
            auto_upcase
            self.company.code = self.company.code.upcase
            self.employee_id = generate_emp_id
      end

      def on_emp_update
            auto_upcase
      end

      def generate_emp_id
            f_init = self.first_name[0, 1]
            l_init = self.last_name[0, 1]
            m_init = self.middle_name[0, 1]
            s_init = self.suffix || ""
            final_init = l_init + f_init + m_init + s_init
            final_init = final_init
            loop do
                  id = "#{self.company.code}-#{final_init}-#{SecureRandom.hex(3).upcase}"
                  break id unless Employee.where(company_id: self.company.id, employee_id: id).exists?
            end
      end

      def auto_upcase
            self.first_name = self.first_name.upcase
            self.last_name = self.last_name.upcase
            self.middle_name = self.middle_name.upcase
            self.suffix = self.suffix.upcase
            self.job_classification = self.job_classification.upcase
            self.position = self.position.upcase
            self.assigned_area = self.assigned_area.upcase
            self.employment_status = self.employment_status.upcase
            self.course = self.course.upcase
            self.course_major = self.course_major.upcase
            self.sex = self.sex.upcase
            self.email = self.email.downcase 
            self.street = self.street.upcase
            self.barangay = self.barangay.upcase
            self.municipality = self.municipality.upcase
            self.province = self.province.upcase
            self.highest_educational_attainment = self.highest_educational_attainment.upcase
            self.institution = self.institution.upcase
            self.emergency_contact_person = self.emergency_contact_person.upcase
      end
end
