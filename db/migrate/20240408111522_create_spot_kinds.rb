class CreateSpotKinds < ActiveRecord::Migration[6.1]
  def change
    create_table :spot_kinds do |t|
      t.references :spot, foreign_key: { to_table: :spots }, type: :integer, null: false
      t.references :kind, foreign_key: { to_table: :kinds }, type: :integer, null: false
      t.timestamps
    end
  end
end
