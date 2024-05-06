class CreateSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :spots do |t|
      t.bigint :user_id, null: false
      t.string :name, null: false
      t.text :introduction, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.timestamps
    end

    add_foreign_key :spots, :users
  end
end