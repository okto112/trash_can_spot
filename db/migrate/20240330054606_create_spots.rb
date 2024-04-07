class CreateSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :spots do |t|
      t.references :user, foreign_key: { to_table: :users }, type: :integer, null: false
      t.string :name, null: false
      t.text :introduction, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.timestamps
    end
  end
end
