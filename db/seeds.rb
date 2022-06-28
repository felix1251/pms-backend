# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
# movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
Company.create(code: 'two_aces', description: 'Two Aces Corporation')
company = Company.last
User.create(position: "HR head", company_id: company.id, hr_head: true, username: "fabacajen", name: "Admin",
            email: "sample@dev.com", password: "password", password_confirmation: "password")
