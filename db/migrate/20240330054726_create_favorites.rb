class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.bigint :user_id, null: false
      t.bigint :spot_id, null: false
      t.timestamps
    end

    add_foreign_key :favorites, :users
    add_foreign_key :favorites, :spots
  end
end
