class PayrollAccount < ApplicationRecord
  belongs_to :payroll
  belongs_to :company_account
  validate :unique_record, :if => [:payroll_id_changed?, :company_account_id_changed?]

  private

  def unique_record
    errors.add(:company_account_id, 'record already exist on payroll id') if find_record_if_exist
  end

  def find_record_if_exist
    PayrollAccount.where("company_account_id = ? AND payroll_id = ?", self.company_account_id, self.payroll_id).any?
  end
end
