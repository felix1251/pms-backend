page_access = [
      {access_code: "H", page: "Dashboard", position: 1},
      {access_code: "E", page: "Employees", position: 2},
      {access_code: "C", page: "Schedules", position: 3},
      {access_code: "T", page: "Time Keeping", position: 4},
      {access_code: "P", page: "Payroll", position: 5},
      {access_code: "B", page: "Benefits and Loans", position: 6},
      {access_code: "Q", page: "Employee Request", position: 7},
      {access_code: "R", page: "Reports", position: 8},
      {access_code: "Y", page: "System Accounts", position: 9},
]

PageAccess.create(page_access)
PageActionAccess.create(access_code: "V", action: "View")
PageActionAccess.create(access_code: "A", action: "Add")
PageActionAccess.create(access_code: "E", action: "Edit")
PageActionAccess.create(access_code: "D", action: "Delete")
PageActionAccess.create(access_code: "X", action: "Export")

Company.create(code: 'erxil', description: 'Erxil Tech. Solutions')

all_access = []

page = PageAccess.order("position ASC").pluck("access_code")
access = PageActionAccess.order("id ASC").pluck("access_code")

page.each do |pg|
      all_access.push(pg)
      if pg == "H"
            access.each do |ac|
                  all_access.push(pg+ac) if ac == "V" 
            end
      elsif pg == "R"
            access.each do |ac|
                  all_access.push(pg+ac) if ac == "V" || ac == "X"
            end
      else
            access.each do |ac|
                  all_access.push(pg+ac)
            end
      end
end

company = Company.first

User.create(position: "Head", company_id: company.id, admin: true, username: "owner", name: "Head", email: "sample5@dev.com",
            password: "password", password_confirmation: "password", system_default: true, page_accesses: all_access)
      
User.create(position: "HR-head", company_id: company.id, admin: true, username: "hrhead", name: "Hr head", email: "sample6@dev.com",
            password: "password", password_confirmation: "password", system_default: true, page_accesses: all_access)

Administrator.create(username: "felix", name: "Felix Abacajen", password: "password", password_confirmation: "password")

PmsDevice.create(company_id: company.id, device_id: "2750bc42-702e-4cbe-bae5-798f171389e1", device_name: "felixiripple-IdeaPad-3-14ITL05")

SalaryMode.create(description: "monthly", code: "mnly")
SalaryMode.create(description: "hourly", code: "hrly")
SalaryMode.create(description: "daily", code: "dly")

EmploymentStatus.create(name: "probationary", code: "prob")
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

Philhealth.create(percentage_deduction: 0.40, title: "As of 2022", status: "A")
Pagibig.create(amount: 100, title: "As of 2022", status: "A")
SssContribution.create(title: "As of 2022", status: "A")

SocialSecuritySystem.create(
[
      {
            "com_from": 0,
            "com_to": 3250,
            "employe_compensation": 3000,
            "mandatory_fund": 0,
            "salary_credit_total": 3000,
            "rss_er": 255,
            "rss_ee": 135,
            "rss_total": 390,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 265,
            "total_ee": 135,
            "final_total": 400
      },
      {
            "com_from": 3250,
            "com_to": 3749.99,
            "employe_compensation": 3500,
            "mandatory_fund": 0,
            "salary_credit_total": 3500,
            "rss_er": 297.5,
            "rss_ee": 157.5,
            "rss_total": 455,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 307.5,
            "total_ee": 157.5,
            "final_total": 465
      },
      {
            "com_from": 3750,
            "com_to": 4249.99,
            "employe_compensation": 4000,
            "mandatory_fund": 0,
            "salary_credit_total": 4000,
            "rss_er": 340,
            "rss_ee": 180,
            "rss_total": 520,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 350,
            "total_ee": 180,
            "final_total": 530
      },
      {
            "com_from": 4250,
            "com_to": 4749.99,
            "employe_compensation": 4500,
            "mandatory_fund": 0,
            "salary_credit_total": 4500,
            "rss_er": 382.5,
            "rss_ee": 202.5,
            "rss_total": 585,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 392.5,
            "total_ee": 202.5,
            "final_total": 595
      },
      {
            "com_from": 4750,
            "com_to": 5249.99,
            "employe_compensation": 5000,
            "mandatory_fund": 0,
            "salary_credit_total": 5000,
            "rss_er": 425,
            "rss_ee": 225,
            "rss_total": 650,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 435,
            "total_ee": 225,
            "final_total": 660
      },
      {
            "com_from": 5250,
            "com_to": 5749.99,
            "employe_compensation": 5500,
            "mandatory_fund": 0,
            "salary_credit_total": 5500,
            "rss_er": 467.5,
            "rss_ee": 247.5,
            "rss_total": 715,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 477.5,
            "total_ee": 247.5,
            "final_total": 725
      },
      {
            "com_from": 5750,
            "com_to": 6249.99,
            "employe_compensation": 6000,
            "mandatory_fund": 0,
            "salary_credit_total": 6000,
            "rss_er": 510,
            "rss_ee": 270,
            "rss_total": 780,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 520,
            "total_ee": 270,
            "final_total": 790
      },
      {
            "com_from": 6250,
            "com_to": 6749.99,
            "employe_compensation": 6500,
            "mandatory_fund": 0,
            "salary_credit_total": 6500,
            "rss_er": 552.5,
            "rss_ee": 292.5,
            "rss_total": 845,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 562.5,
            "total_ee": 292.5,
            "final_total": 855
      },
      {
            "com_from": 6750,
            "com_to": 7249.99,
            "employe_compensation": 7000,
            "mandatory_fund": 0,
            "salary_credit_total": 7000,
            "rss_er": 595,
            "rss_ee": 315,
            "rss_total": 910,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 605,
            "total_ee": 315,
            "final_total": 920
      },
      {
            "com_from": 7250,
            "com_to": 7749.99,
            "employe_compensation": 7500,
            "mandatory_fund": 0,
            "salary_credit_total": 7500,
            "rss_er": 637.5,
            "rss_ee": 337.5,
            "rss_total": 975,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 647.5,
            "total_ee": 337.5,
            "final_total": 985
      },
      {
            "com_from": 7750,
            "com_to": 8249.99,
            "employe_compensation": 8000,
            "mandatory_fund": 0,
            "salary_credit_total": 8000,
            "rss_er": 680,
            "rss_ee": 360,
            "rss_total": 1040,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 690,
            "total_ee": 360,
            "final_total": 1050
      },
      {
            "com_from": 8250,
            "com_to": 8749.99,
            "employe_compensation": 8500,
            "mandatory_fund": 0,
            "salary_credit_total": 8500,
            "rss_er": 722.5,
            "rss_ee": 382.5,
            "rss_total": 1105,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 732.5,
            "total_ee": 382.5,
            "final_total": 1115
      },
      {
            "com_from": 8750,
            "com_to": 9249.99,
            "employe_compensation": 9000,
            "mandatory_fund": 0,
            "salary_credit_total": 9000,
            "rss_er": 765,
            "rss_ee": 405,
            "rss_total": 1170,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 775,
            "total_ee": 405,
            "final_total": 1180
      },
      {
            "com_from": 9250,
            "com_to": 9749.99,
            "employe_compensation": 9500,
            "mandatory_fund": 0,
            "salary_credit_total": 9500,
            "rss_er": 807.5,
            "rss_ee": 427.5,
            "rss_total": 1235,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 817.5,
            "total_ee": 427.5,
            "final_total": 1245
      },
      {
            "com_from": 9750,
            "com_to": 10249.99,
            "employe_compensation": 10000,
            "mandatory_fund": 0,
            "salary_credit_total": 10000,
            "rss_er": 850,
            "rss_ee": 450,
            "rss_total": 1300,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 860,
            "total_ee": 450,
            "final_total": 1310
      },
      {
            "com_from": 10250,
            "com_to": 10749.99,
            "employe_compensation": 10500,
            "mandatory_fund": 0,
            "salary_credit_total": 10500,
            "rss_er": 892.5,
            "rss_ee": 472.5,
            "rss_total": 1365,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 902.5,
            "total_ee": 472.5,
            "final_total": 1375
      },
      {
            "com_from": 10750,
            "com_to": 11249.99,
            "employe_compensation": 11000,
            "mandatory_fund": 0,
            "salary_credit_total": 11000,
            "rss_er": 935,
            "rss_ee": 495,
            "rss_total": 1430,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 945,
            "total_ee": 495,
            "final_total": 1440
      },
      {
            "com_from": 11250,
            "com_to": 11749.99,
            "employe_compensation": 11500,
            "mandatory_fund": 0,
            "salary_credit_total": 11500,
            "rss_er": 977.5,
            "rss_ee": 517.5,
            "rss_total": 1495,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 987.5,
            "total_ee": 517.5,
            "final_total": 1505
      },
      {
            "com_from": 11750,
            "com_to": 12249.99,
            "employe_compensation": 12000,
            "mandatory_fund": 0,
            "salary_credit_total": 12000,
            "rss_er": 1020,
            "rss_ee": 540,
            "rss_total": 1560,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1030,
            "total_ee": 540,
            "final_total": 1570
      },
      {
            "com_from": 12250,
            "com_to": 12749.99,
            "employe_compensation": 12500,
            "mandatory_fund": 0,
            "salary_credit_total": 12500,
            "rss_er": 1062.5,
            "rss_ee": 562.5,
            "rss_total": 1625,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1072.5,
            "total_ee": 562.5,
            "final_total": 1635
      },
      {
            "com_from": 12750,
            "com_to": 13249.99,
            "employe_compensation": 13000,
            "mandatory_fund": 0,
            "salary_credit_total": 13000,
            "rss_er": 1105,
            "rss_ee": 585,
            "rss_total": 1690,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1115,
            "total_ee": 585,
            "final_total": 1700
      },
      {
            "com_from": 13250,
            "com_to": 13749.99,
            "employe_compensation": 13500,
            "mandatory_fund": 0,
            "salary_credit_total": 13500,
            "rss_er": 1147.5,
            "rss_ee": 607.5,
            "rss_total": 1755,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1157.5,
            "total_ee": 607.5,
            "final_total": 1765
      },
      {
            "com_from": 13750,
            "com_to": 14249.99,
            "employe_compensation": 14000,
            "mandatory_fund": 0,
            "salary_credit_total": 14000,
            "rss_er": 1190,
            "rss_ee": 630,
            "rss_total": 1820,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1200,
            "total_ee": 630,
            "final_total": 1830
      },
      {
            "com_from": 14250,
            "com_to": 14749.99,
            "employe_compensation": 14500,
            "mandatory_fund": 0,
            "salary_credit_total": 14500,
            "rss_er": 1232.5,
            "rss_ee": 652.5,
            "rss_total": 1885,
            "ec_er": 10,
            "ec_ee": 0,
            "ec_total": 10,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1242.5,
            "total_ee": 652.5,
            "final_total": 1895
      },
      {
            "com_from": 14750,
            "com_to": 15249.99,
            "employe_compensation": 15000,
            "mandatory_fund": 0,
            "salary_credit_total": 15000,
            "rss_er": 1275,
            "rss_ee": 675,
            "rss_total": 1950,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1305,
            "total_ee": 675,
            "final_total": 1980
      },
      {
            "com_from": 15250,
            "com_to": 15749.99,
            "employe_compensation": 15500,
            "mandatory_fund": 0,
            "salary_credit_total": 15500,
            "rss_er": 1317.5,
            "rss_ee": 697.5,
            "rss_total": 2015,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1347.5,
            "total_ee": 697.5,
            "final_total": 2045
      },
      {
            "com_from": 15750,
            "com_to": 16249.99,
            "employe_compensation": 16000,
            "mandatory_fund": 0,
            "salary_credit_total": 16000,
            "rss_er": 1360,
            "rss_ee": 720,
            "rss_total": 2080,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1390,
            "total_ee": 720,
            "final_total": 2110
      },
      {
            "com_from": 16250,
            "com_to": 16749.99,
            "employe_compensation": 16500,
            "mandatory_fund": 0,
            "salary_credit_total": 16500,
            "rss_er": 1402.5,
            "rss_ee": 742.5,
            "rss_total": 2145,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1432.5,
            "total_ee": 742.5,
            "final_total": 2175
      },
      {
            "com_from": 16750,
            "com_to": 17249.99,
            "employe_compensation": 17000,
            "mandatory_fund": 0,
            "salary_credit_total": 17000,
            "rss_er": 1445,
            "rss_ee": 765,
            "rss_total": 2210,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1475,
            "total_ee": 765,
            "final_total": 2240
      },
      {
            "com_from": 17250,
            "com_to": 17749.99,
            "employe_compensation": 17500,
            "mandatory_fund": 0,
            "salary_credit_total": 17500,
            "rss_er": 1487.5,
            "rss_ee": 787.5,
            "rss_total": 2275,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1517.5,
            "total_ee": 787.5,
            "final_total": 2305
      },
      {
            "com_from": 17750,
            "com_to": 18249.99,
            "employe_compensation": 18000,
            "mandatory_fund": 0,
            "salary_credit_total": 18000,
            "rss_er": 1530,
            "rss_ee": 810,
            "rss_total": 2340,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1560,
            "total_ee": 810,
            "final_total": 2370
      },
      {
            "com_from": 18250,
            "com_to": 18749.99,
            "employe_compensation": 18500,
            "mandatory_fund": 0,
            "salary_credit_total": 18500,
            "rss_er": 1572.5,
            "rss_ee": 832.5,
            "rss_total": 2405,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1602.5,
            "total_ee": 832.5,
            "final_total": 2435
      },
      {
            "com_from": 18750,
            "com_to": 19249.99,
            "employe_compensation": 19000,
            "mandatory_fund": 0,
            "salary_credit_total": 19000,
            "rss_er": 1615,
            "rss_ee": 855,
            "rss_total": 2470,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1645,
            "total_ee": 855,
            "final_total": 2500
      },
      {
            "com_from": 19250,
            "com_to": 19749.99,
            "employe_compensation": 19500,
            "mandatory_fund": 0,
            "salary_credit_total": 19500,
            "rss_er": 1657.5,
            "rss_ee": 877.5,
            "rss_total": 2535,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1687.5,
            "total_ee": 877.5,
            "final_total": 2565
      },
      {
            "com_from": 19750,
            "com_to": 20249.99,
            "employe_compensation": 20000,
            "mandatory_fund": 0,
            "salary_credit_total": 20000,
            "rss_er": 1700,
            "rss_ee": 900,
            "rss_total": 2600,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 0,
            "mpf_ee": 0,
            "mpf_total": 0,
            "total_er": 1730,
            "total_ee": 900,
            "final_total": 2630
      },
      {
            "com_from": 20250,
            "com_to": 20749.99,
            "employe_compensation": 20000,
            "mandatory_fund": 500,
            "salary_credit_total": 20500,
            "rss_er": 1700,
            "rss_ee": 900,
            "rss_total": 2600,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 42.5,
            "mpf_ee": 22.5,
            "mpf_total": 65,
            "total_er": 1772.5,
            "total_ee": 922.5,
            "final_total": 2695
      },
      {
            "com_from": 20750,
            "com_to": 21249.99,
            "employe_compensation": 20000,
            "mandatory_fund": 1000,
            "salary_credit_total": 21000,
            "rss_er": 1700,
            "rss_ee": 900,
            "rss_total": 2600,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 85,
            "mpf_ee": 45,
            "mpf_total": 130,
            "total_er": 1815,
            "total_ee": 945,
            "final_total": 2760
      },
      {
            "com_from": 21250,
            "com_to": 21749.99,
            "employe_compensation": 20000,
            "mandatory_fund": 1500,
            "salary_credit_total": 21500,
            "rss_er": 1700,
            "rss_ee": 900,
            "rss_total": 2600,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 127.5,
            "mpf_ee": 67.5,
            "mpf_total": 195,
            "total_er": 1857.5,
            "total_ee": 967.5,
            "final_total": 2825
      },
      {
            "com_from": 21750,
            "com_to": 22249.99,
            "employe_compensation": 20000,
            "mandatory_fund": 2000,
            "salary_credit_total": 22000,
            "rss_er": 1700,
            "rss_ee": 900,
            "rss_total": 2600,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 170,
            "mpf_ee": 90,
            "mpf_total": 260,
            "total_er": 1900,
            "total_ee": 990,
            "final_total": 2890
      },
      {
            "com_from": 22250,
            "com_to": 22749.99,
            "employe_compensation": 20000,
            "mandatory_fund": 2500,
            "salary_credit_total": 22500,
            "rss_er": 1700,
            "rss_ee": 900,
            "rss_total": 2600,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 212.5,
            "mpf_ee": 112.5,
            "mpf_total": 325,
            "total_er": 1942.5,
            "total_ee": 1012.5,
            "final_total": 2955
      },
      {
            "com_from": 22750,
            "com_to": 23249.99,
            "employe_compensation": 20000,
            "mandatory_fund": 3000,
            "salary_credit_total": 23000,
            "rss_er": 1700,
            "rss_ee": 900,
            "rss_total": 2600,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 255,
            "mpf_ee": 135,
            "mpf_total": 390,
            "total_er": 1985,
            "total_ee": 1035,
            "final_total": 3020
      },
      {
            "com_from": 23250,
            "com_to": 23749.99,
            "employe_compensation": 20000,
            "mandatory_fund": 3500,
            "salary_credit_total": 23500,
            "rss_er": 1700,
            "rss_ee": 900,
            "rss_total": 2600,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 297.5,
            "mpf_ee": 157.5,
            "mpf_total": 455,
            "total_er": 2027.5,
            "total_ee": 1057.5,
            "final_total": 3085
      },
      {
            "com_from": 23750,
            "com_to": 24249.99,
            "employe_compensation": 20000,
            "mandatory_fund": 4000,
            "salary_credit_total": 24000,
            "rss_er": 1700,
            "rss_ee": 900,
            "rss_total": 2600,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 340,
            "mpf_ee": 180,
            "mpf_total": 520,
            "total_er": 2070,
            "total_ee": 1080,
            "final_total": 3150
      },
      {
            "com_from": 24250,
            "com_to": 24749.99,
            "employe_compensation": 20000,
            "mandatory_fund": 4500,
            "salary_credit_total": 24500,
            "rss_er": 1700,
            "rss_ee": 900,
            "rss_total": 2600,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 382.5,
            "mpf_ee": 202.5,
            "mpf_total": 585,
            "total_er": 2112.5,
            "total_ee": 1102.5,
            "final_total": 3215
      },
      {
            "com_from": 24750,
            "com_to": 500000,
            "employe_compensation": 20000,
            "mandatory_fund": 5000,
            "salary_credit_total": 25000,
            "rss_er": 1700,
            "rss_ee": 900,
            "rss_total": 2600,
            "ec_er": 30,
            "ec_ee": 0,
            "ec_total": 30,
            "mpf_er": 425,
            "mpf_ee": 225,
            "mpf_total": 650,
            "total_er": 2155,
            "total_ee": 1125,
            "final_total": 3280
      }
])

sss = SssContribution.first
SocialSecuritySystem.all.update(sss_contribution_id: sss.id)
