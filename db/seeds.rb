Company.create(code: 'two_aces', description: 'Two Aces Corporation')
company = Company.last

User.create(position: "HR head", company_id: company.id, hr_head: true, username: "fabacajen", name: "Admin",
            email: "sample@dev.com", password: "password", password_confirmation: "password")
user = User.first

PageAccess.create(access_code: "D", page: "dashboard")
PageAccess.create(access_code: "P", page: "payroll")
PageAccess.create(access_code: "T", page: "time keeping")
PageActionAccess.create(access_code: "A", action: "add")
PageActionAccess.create(access_code: "E", action: "edit")
PageActionAccess.create(access_code: "D", action: "delete")
PageActionAccess.create(access_code: "X", action: "export")
# SessionRecord.create(user_id: user.id)
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
UserPageActionAccess.create(user_id: user.id, page_access_id: 4, page_action_access_id: 1, status: "A")
UserPageActionAccess.create(user_id: user.id, page_access_id: 4, page_action_access_id: 2, status: "A")
UserPageActionAccess.create(user_id: user.id, page_access_id: 4, page_action_access_id: 3, status: "A")
UserPageActionAccess.create(user_id: user.id, page_access_id: 4, page_action_access_id: 4, status: "A")

