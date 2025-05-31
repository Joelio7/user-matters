class CreateMatters < ActiveRecord::Migration[8.0]
  def change
    create_table :matters do |t|
      t.string :title, null: false
      t.text :description
      t.string :state, default: 'new', null: false
      t.datetime :due_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :matters, :state
    add_index :matters, :due_date
  end
end