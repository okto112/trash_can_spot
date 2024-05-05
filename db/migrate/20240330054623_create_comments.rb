class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: { to_table: :users }, type: :integer, null: false
      t.references :spot, foreign_key: { to_table: :spots }, type: :integer, null: false
      t.text :comment, null: false
      t.timestamps
    end
  end
end
