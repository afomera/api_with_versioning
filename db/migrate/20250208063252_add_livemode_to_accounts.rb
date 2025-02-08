class AddLivemodeToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :livemode, :boolean, null: false, default: false
    add_index :accounts, :livemode
  end
end
