class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.bigint :user_id, null: false
      t.bigint :spot_id, null: false
      t.text :comment, null: false
      t.timestamps
    end

    add_foreign_key :comments, :users
    add_foreign_key :comments, :spots
  end
end
