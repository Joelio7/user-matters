class AddFirmNameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :firm_name, :string
    add_index :users, :firm_name
  end
end