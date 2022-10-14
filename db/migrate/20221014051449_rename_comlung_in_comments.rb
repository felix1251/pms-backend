class RenameComlungInComments < ActiveRecord::Migration[5.2]
  def change
    rename_column :payroll_comments, :type, :comment_type
  end
end
