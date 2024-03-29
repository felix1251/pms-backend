class Employee < ApplicationRecord
      include BCrypt
      has_secure_password
      belongs_to :company
      belongs_to :department
      belongs_to :salary_mode
      belongs_to :position
      belongs_to :employment_status
      belongs_to :created_by, class_name: "User"
      has_many :employee_action_histories
      has_many :compensation_histories
      has_many :leaves
      has_many :official_businesses
      has_many :allowances
      has_many :on_payroll_adjustment

      before_validation :emp_set_password, on: :create
      before_create :on_emp_create
      before_update :on_emp_update

      validates :first_name, presence: true
      validates :last_name, presence: true
      validates :sex, presence: true
      validates :birthdate, presence: true
      validates :phone_number, presence: true
      validates :highest_educational_attainment, presence: true
      validates :position, presence: true
      validates :date_hired, presence: true
      validates :employment_status, presence: true
      validates :compensation, presence: true
      validates :biometric_no, uniqueness: { scope: :company_id }
      validates :email, allow_blank: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP , :message => "email format is invalid"}
      validates :company_email, allow_blank: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP , :message => "email format is invalid"}
      validates :work_sched_type, presence: true
      enum status: { A: "A", I: "I", P: "P"}
      enum work_sched_type: { FX: "FX", FL: "FL"}
      # enum sex: { male: "male", female: "female", MALE: "MALE", FEMALE: "FEMALE"}

      def attributes
            super.except('password_digest')
      end

      private

      def emp_set_password
            self.employee_id = generate_emp_id
            self.password = self.employee_id 
            self.password_confirmation = self.password
      end

      def on_emp_create
            auto_upcase
            self.status = "P" if self.company.settings["employeePageApprovalOnCreate"]
      end

      def on_emp_update
            auto_upcase
            set_compensation_history if self.compensation_changed?
      end

      def generate_emp_id
            f_init = self.first_name[0, 1]
            l_init = self.last_name[0, 1]
            m_init = self.middle_name[0, 1]
            s_init = self.suffix || ""
            final_init = l_init + f_init + m_init + s_init
            final_init = final_init.split.join
            loop do
                  id = "#{self.company.code}-#{final_init}-#{SecureRandom.hex(3)}"
                  break id.upcase unless Employee.where(company_id: self.company.id, employee_id: id.upcase).exists?
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
            self.emergency_contact_relationship = self.emergency_contact_relationship.upcase
            self.civil_status = self.civil_status.upcase
            self.graduate_school = self.graduate_school.upcase
      end

      def set_compensation_history
            CompensationHistory.create(compensation: self.compensation, employee_id: self.id, description: "UPDATE")
      end
end
