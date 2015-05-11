class AddIdealDataToPayments < ActiveRecord::Migration

  def change
    add_column :spree_payments, :ideal_hash, :string
    add_column :spree_payments, :ideal_transaction, :string
    add_column :spree_payments, :ideal_log, :string
  end

end
