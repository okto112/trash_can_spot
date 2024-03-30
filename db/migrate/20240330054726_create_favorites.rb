class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: { to_table: :users }, type: :integer, null: false
      t.references :spot, foreign_key: { to_table: :spots }, type: :integer, null: false
      t.timestamps
    end
  end
end
