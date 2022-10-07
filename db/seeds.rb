page_access = [
      {access_code: "H", page: "Dashboard"},
      {access_code: "E", page: "Employees"},
      {access_code: "P", page: "Payroll"},
      {access_code: "B", page: "Benefits"},
      {access_code: "T", page: "Time Keeping"},
      {access_code: "S", page: "System Accounts"},
      {access_code: "C", page: "Schedules"},
      {access_code: "R", page: "Employee Request"},
]

PageAccess.create(page_access)

PageActionAccess.create(access_code: "V", action: "View")
PageActionAccess.create(access_code: "A", action: "Add")
PageActionAccess.create(access_code: "E", action: "Edit")
PageActionAccess.create(access_code: "D", action: "Delete")
PageActionAccess.create(access_code: "X", action: "Export")

Company.create(code: 'erxil', description: 'Erxil Tech. Solutions')

company = Company.first

User.create(position: "Head", company_id: company.id, admin: true, username: "owner", name: "Head",
                  email: "sample5@dev.com", password: "password", password_confirmation: "password", system_default: true)
      
User.create(position: "HR-head", company_id: company.id, admin: true, username: "hrhead", name: "Hr head",
                  email: "sample6@dev.com", password: "password", password_confirmation: "password", system_default: true)

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

SalaryMode.create(description: "monthly", code: "mnly")
SalaryMode.create(description: "hourly", code: "hrly")
SalaryMode.create(description: "daily", code: "dly")

EmploymentStatus.create(name: "probitionary", code: "prob")
EmploymentStatus.create(name: "regular", code: "reg")
EmploymentStatus.create(name: "seasonal", code: "ses")

TypeOfLeave.create(name: 'Sick leave with pay', with_pay: true)
TypeOfLeave.create(name: 'Sick leave w/o pay', with_pay: false)
TypeOfLeave.create(name: 'Vacation leave with pay', with_pay: true)
TypeOfLeave.create(name: 'Vacation leave w/o pay', with_pay: false)
TypeOfLeave.create(name: 'Emergency leave with pay', with_pay: true)
TypeOfLeave.create(name: 'Emergency leave w/o pay', with_pay: false)
TypeOfLeave.create(name: 'Maternity/Paternity Leave with pay', with_pay: true)
TypeOfLeave.create(name: 'Maternity/Paternity Leave w/o pay', with_pay: false)
TypeOfLeave.create(name: 'Birthday leave', with_pay: true)
