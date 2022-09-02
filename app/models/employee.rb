class Employee < ApplicationRecord
      serialize :work_sched_days, Array
      belongs_to :company
      belongs_to :department
      belongs_to :salary_mode
      belongs_to :position
      belongs_to :employment_status
      has_many :employee_action_histories
      belongs_to :created_by, class_name: "User"

      before_create :add_custom_column_data
      before_update :on_emp_update

      secret_key =  [Rails.application.credentials[:DB_COL_ENCRYPTED_KEY]].pack("H*")
      # secret_iv =  [Rails.application.credentials[:DB_COL_ENCRYPTED_IV]].pack("H*")
      attr_encrypted :compensation, key: secret_key, mode: :per_attribute_iv_and_salt, insecure_mode: true, algorithm: 'aes-256-cbc', marshal: true

      validates :first_name, presence: true
      validates :last_name, presence: true
      validates :middle_name, presence: true
      validates :sex, presence: true
      validates :birthdate, presence: true
      validates :civil_status, presence: true
      validates :phone_number, presence: true
      validates :street, presence: true
      validates :barangay, presence: true
      validates :municipality, presence: true
      validates :province, presence: true
      validates :highest_educational_attainment, presence: true
      validates :position, presence: true
      validates :date_hired, presence: true
      validates :employment_status, presence: true
      validates :compensation, numericality: { only_integer: true }, presence: true
      validates :biometric_no, uniqueness: { scope: :company_id }, allow_blank: true, exclusion: { in: ["", nil]}
      validates :email, allow_blank: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP , :message => "email format is invalid"}
      validates :company_email, allow_blank: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP , :message => "email format is invalid"}
      validates :work_sched_type, presence: true
      enum status: { A: "A", I: "I"}
      enum work_sched_type: { FX: "FX", FL: "FL"}
      enum sex: { male: "male", female: "female", MALE: "MALE", FEMALE: "FEMALE"}
      
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
            self.civil_status = self.civil_status.upcase
            self.graduate_school = self.graduate_school.upcase
            # self.work_sched_start = ActiveSupport::TimeZone['UTC'].parse(self.work_sched_start)
            # self.work_sched_end =  ActiveSupport::TimeZone['UTC'].parse(self.work_sched_end)
      end
end
