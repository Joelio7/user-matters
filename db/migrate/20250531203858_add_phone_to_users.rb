class AddPhoneToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :phone, :string, null: false
    add_index :users, :phone
  end
end