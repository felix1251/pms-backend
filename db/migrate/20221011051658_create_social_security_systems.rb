class CreateSocialSecuritySystems < ActiveRecord::Migration[5.2]
  def change
    create_table :social_security_systems do |t|
      t.decimal :com_from, :precision => 8, :scale => 2, null: false
      t.decimal :com_to, :precision => 8, :scale => 2, null: false
      t.decimal :employe_compensation, :precision => 8, :scale => 2, null: false
      t.decimal :mandatory_fund, :precision => 8, :scale => 2, null: false
      t.decimal :salary_credit_total, :precision => 8, :scale => 2, null: false
      t.decimal :rss_er, :precision => 8, :scale => 2, null: false
      t.decimal :rss_ee, :precision => 8, :scale => 2, null: false
      t.decimal :rss_total, :precision => 8, :scale => 2, null: false
      t.decimal :ec_er, :precision => 8, :scale => 2, null: false
      t.decimal :ec_ee, :precision => 8, :scale => 2, null: false
      t.decimal :ec_total, :precision => 8, :scale => 2, null: false
      t.decimal :mpf_er, :precision => 8, :scale => 2, null: false
      t.decimal :mpf_ee, :precision => 8, :scale => 2, null: false
      t.decimal :mpf_total, :precision => 8, :scale => 2, null: false
      t.decimal :total_er, :precision => 8, :scale => 2, null: false
      t.decimal :total_ee, :precision => 8, :scale => 2, null: false
      t.decimal :final_total, :precision => 8, :scale => 2, null: false

      t.timestamps
    end
  end
end
