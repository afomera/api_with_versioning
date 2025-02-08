class AddModeToApiSecretKeys < ActiveRecord::Migration[8.0]
  def change
    add_column :api_secret_keys, :mode, :string, null: false, default: 'test'
    add_index :api_secret_keys, :mode
  end
end
