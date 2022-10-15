class ChangeCommentsToUtf8mb4 < ActiveRecord::Migration[5.2]
  def up
    execute "ALTER TABLE payroll_comments CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE payroll_comments MODIFY comment TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
  end
  def down
    execute "ALTER TABLE payroll_comments CONVERT TO CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE payroll_comments MODIFY comment TEXT CHARACTER SET utf8 COLLATE utf8_bin"
  end
end
