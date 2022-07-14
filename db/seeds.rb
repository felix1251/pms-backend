PageAccess.create(access_code: "D", page: "dashboard")
PageAccess.create(access_code: "P", page: "payroll")
PageAccess.create(access_code: "T", page: "time keeping")
PageActionAccess.create(access_code: "A", action: "add")
PageActionAccess.create(access_code: "E", action: "edit")
PageActionAccess.create(access_code: "D", action: "delete")
PageActionAccess.create(access_code: "X", action: "export")

Company.create(code: 'two_aces', description: 'Two Aces Corporation')
company = Company.last

User.create(position: "Head", company_id: company.id, admin: true, username: "owner", name: "Head",
            email: "sample@dev.com", password: "password", password_confirmation: "password")

User.create(position: "HR-head", company_id: company.id, admin: true, username: "hrhead", name: "Hr head",
            email: "sample2@dev.com", password: "password", password_confirmation: "password")

User.create(position: "HR-Time Keeping", company_id: company.id, admin: false, username: "hrtimekeeping", name: "Time Keeping Account",
            email: "sample3@dev.com", password: "password", password_confirmation: "password")

User.create(position: "HR-Payroll", company_id: company.id, admin: false, username: "hrpayroll", name: "Payroll Account",
            email: "sample4@dev.com", password: "password", password_confirmation: "password")


users = User.where("admin = true")

users.each do |user|
      UserPageAccess.create(user_id: user.id, page_access_id: 1, status: "A")
      UserPageAccess.create(user_id: user.id, page_access_id: 2, status: "A")
      UserPageAccess.create(user_id: user.id, page_access_id: 3, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 1, page_action_access_id: 1, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 1, page_action_access_id: 2, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 1, page_action_access_id: 3, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 1, page_action_access_id: 4, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 2, page_action_access_id: 1, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 2, page_action_access_id: 2, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 2, page_action_access_id: 3, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 2, page_action_access_id: 4, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 3, page_action_access_id: 1, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 3, page_action_access_id: 2, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 3, page_action_access_id: 3, status: "A")
      UserPageActionAccess.create(user_id: user.id, page_access_id: 3, page_action_access_id: 4, status: "A")
end

time_keeping = User.where("position = 'HR-Time Keeping' AND admin = false")

time_keeping.each do |tk|
      UserPageAccess.create(user_id: tk.id, page_access_id: 1, status: "I")
      UserPageAccess.create(user_id: tk.id, page_access_id: 2, status: "I")
      UserPageAccess.create(user_id: tk.id, page_access_id: 3, status: "A")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 1, page_action_access_id: 1, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 1, page_action_access_id: 2, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 1, page_action_access_id: 3, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 1, page_action_access_id: 4, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 2, page_action_access_id: 1, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 2, page_action_access_id: 2, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 2, page_action_access_id: 3, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 2, page_action_access_id: 4, status: "I")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 3, page_action_access_id: 1, status: "A")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 3, page_action_access_id: 2, status: "A")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 3, page_action_access_id: 3, status: "A")
      UserPageActionAccess.create(user_id: tk.id, page_access_id: 3, page_action_access_id: 4, status: "A")
end

payroll = User.where("position = 'HR-Payroll' AND admin = false")

payroll.each do |pr|
      UserPageAccess.create(user_id: pr.id, page_access_id: 1, status: "I")
      UserPageAccess.create(user_id: pr.id, page_access_id: 2, status: "A")
      UserPageAccess.create(user_id:pr.id, page_access_id: 3, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 1, page_action_access_id: 1, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 1, page_action_access_id: 2, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 1, page_action_access_id: 3, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 1, page_action_access_id: 4, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 2, page_action_access_id: 1, status: "A")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 2, page_action_access_id: 2, status: "A")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 2, page_action_access_id: 3, status: "A")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 2, page_action_access_id: 4, status: "A")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 3, page_action_access_id: 1, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 3, page_action_access_id: 2, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 3, page_action_access_id: 3, status: "I")
      UserPageActionAccess.create(user_id: pr.id, page_access_id: 3, page_action_access_id: 4, status: "I")
end

