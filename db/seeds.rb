PageAccess.create(access_code: "H", page: "Dashboard")
PageAccess.create(access_code: "E", page: "Employees")
PageAccess.create(access_code: "P", page: "Payroll")
PageAccess.create(access_code: "B", page: "Benefits")
PageAccess.create(access_code: "T", page: "Time Keeping")
PageAccess.create(access_code: "S", page: "System Accounts")
PageActionAccess.create(access_code: "V", action: "View")
PageActionAccess.create(access_code: "A", action: "Add")
PageActionAccess.create(access_code: "E", action: "Edit")
PageActionAccess.create(access_code: "D", action: "Delete")
PageActionAccess.create(access_code: "X", action: "Export")

Company.create(code: 'tavdc', description: 'Two Aces Corporation')
company = Company.last

User.create(position: "Head", company_id: company.id, admin: true, username: "owner", name: "Head",
            email: "sample@dev.com", password: "password", password_confirmation: "password", system_default: true)

User.create(position: "HR-head", company_id: company.id, admin: true, username: "hrhead", name: "Hr head",
            email: "sample2@dev.com", password: "password", password_confirmation: "password", system_default: true)

User.create(position: "HR-Time Keeping", company_id: company.id, admin: false, username: "hrtimekeeping", name: "Time Keeping Account",
            email: "sample3@dev.com", password: "password", password_confirmation: "password", system_default: true)

User.create(position: "HR-Payroll", company_id: company.id, admin: false, username: "hrpayroll", name: "Payroll Account",
            email: "sample4@dev.com", password: "password", password_confirmation: "password", system_default: true)
            
users = User.where("admin = true")

users.each do |user|
      UserPageActionAccess.create(user_id: user.id, page_access_id: 1, page_action_access_id: 1, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 2, page_action_access_id: 1, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 2, page_action_access_id: 2, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 2, page_action_access_id: 3, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 2, page_action_access_id: 4, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 2, page_action_access_id: 5, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 2, page_action_access_id: 4, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 3, page_action_access_id: 1, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 3, page_action_access_id: 2, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 3, page_action_access_id: 3, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 3, page_action_access_id: 4, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 3, page_action_access_id: 5, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 4, page_action_access_id: 1, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 4, page_action_access_id: 2, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 4, page_action_access_id: 3, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 4, page_action_access_id: 4, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 4, page_action_access_id: 5, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 5, page_action_access_id: 1, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 5, page_action_access_id: 2, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 5, page_action_access_id: 3, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 5, page_action_access_id: 4, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 5, page_action_access_id: 5, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 6, page_action_access_id: 1, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 6, page_action_access_id: 2, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 6, page_action_access_id: 3, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 6, page_action_access_id: 4, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 6, page_action_access_id: 5, status: "A")
end

time_keeping = User.where("position = 'HR-Time Keeping' AND admin = false")

time_keeping.each do |tk|
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 1, page_action_access_id: 1, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 2, page_action_access_id: 1, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 2, page_action_access_id: 2, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 2, page_action_access_id: 3, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 2, page_action_access_id: 4, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 2, page_action_access_id: 5, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 3, page_action_access_id: 1, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 3, page_action_access_id: 2, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 3, page_action_access_id: 3, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 3, page_action_access_id: 4, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 3, page_action_access_id: 5, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 4, page_action_access_id: 1, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 4, page_action_access_id: 2, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 4, page_action_access_id: 3, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 4, page_action_access_id: 4, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 4, page_action_access_id: 5, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 5, page_action_access_id: 1, status: "A")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 5, page_action_access_id: 2, status: "A")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 5, page_action_access_id: 3, status: "A")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 5, page_action_access_id: 4, status: "A")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 5, page_action_access_id: 5, status: "A")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 6, page_action_access_id: 1, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 6, page_action_access_id: 2, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 6, page_action_access_id: 3, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 6, page_action_access_id: 4, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 6, page_action_access_id: 5, status: "I")
end

payroll = User.where("position = 'HR-Payroll' AND admin = false")

payroll.each do |pr|
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 1, page_action_access_id: 1, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 2, page_action_access_id: 1, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 2, page_action_access_id: 2, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 2, page_action_access_id: 3, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 2, page_action_access_id: 4, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 2, page_action_access_id: 5, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 3, page_action_access_id: 1, status: "A")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 3, page_action_access_id: 2, status: "A")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 3, page_action_access_id: 3, status: "A")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 3, page_action_access_id: 4, status: "A")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 3, page_action_access_id: 5, status: "A")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 4, page_action_access_id: 1, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 4, page_action_access_id: 2, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 4, page_action_access_id: 3, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 4, page_action_access_id: 4, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 4, page_action_access_id: 5, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 5, page_action_access_id: 1, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 5, page_action_access_id: 2, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 5, page_action_access_id: 3, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 5, page_action_access_id: 4, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 5, page_action_access_id: 5, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 6, page_action_access_id: 1, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 6, page_action_access_id: 2, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 6, page_action_access_id: 3, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 6, page_action_access_id: 4, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 6, page_action_access_id: 5, status: "I")      
end

Department.create!(company_id: 1, name: "store 1", code: "s1")
SalaryMode.create!(description: "monthly", code: "mnly")
SalaryMode.create!(description: "hourly", code: "hrly")
SalaryMode.create!(description: "daily", code: "dly")

Employee.create!(company_id: 1, first_name: "lyra", middle_name: "pacundo", last_name: "espinosa", suffix: "", biometric_no: 100, position: "hr generalist", 
                  department_id: 1, assigned_area: "kitcharao", job_classification: "staff", salary_mode_id: 1, date_hired: Date.today, date_resigned: "", 
                  employment_status: "sample", sex: "female", birthdate: "February 20, 1998", age: 23, phone_number: "09079247641", email: "sample@dev.com",
                  street: "purok 2", barangay: "crossing", municipality: "kitcharao", province: "agusan del norte", sss_no: "122-2121-212121", 
                  hdmf_no: "121-2121-2121-21", tin_no: "212-2121-212", phic_no: "1212-212-2121", highest_educational_attainment: "college graduate",
                  institution: "Agusan Colleges", course: "bachelor of Science in business administration", course_major: "major in marketing management", compensation: 30000)

Employee.create!(company_id: 1, first_name: "felix", middle_name: "gallardo", last_name: "abacajen", suffix: "jr", biometric_no: 101, position: "backned developer", 
                  department_id: 1, assigned_area: "kitcharao", job_classification: "staff", salary_mode_id: 1, date_hired: Date.today, date_resigned: "", 
                  employment_status: "sample", sex: "female", birthdate: "February 26, 1998", age: 23, phone_number: "09079247641", email: "sample1@dev.com",
                  street: "purok 2", barangay: "crossing", municipality: "kitcharao", province: "agusan del norte", sss_no: "122-2121-212121", 
                  hdmf_no: "121-2121-2121-21", tin_no: "212-2121-212", phic_no: "1212-212-2121", highest_educational_attainment: "college graduate",
                  institution: "Agusan Colleges", course: "bachelor of science in computer science", course_major: "major in software engineering" , compensation: 30000)

Employee.create!(company_id: 1, first_name: "john christian", middle_name: "gellermo", last_name: "salazar", suffix: "", biometric_no: 102, position: "crew", 
                  department_id: 1, assigned_area: "kitcharao", job_classification: "staff", salary_mode_id: 3, date_hired: Date.today, date_resigned: "", 
                  employment_status: "sample", sex: "female", birthdate: "February 26, 1998", age: 23, phone_number: "09079247641", email: "sample2@dev.com",
                  street: "purok 2", barangay: "crossing", municipality: "kitcharao", province: "agusan del norte", sss_no: "122-2121-212121", 
                  hdmf_no: "121-2121-2121-21", tin_no: "212-2121-212", phic_no: "1212-212-2121", highest_educational_attainment: "college graduate",
                  institution: "Agusan Colleges", course: "bachelor of science in computer science", course_major: "major in software engineering", compensation: 30000)