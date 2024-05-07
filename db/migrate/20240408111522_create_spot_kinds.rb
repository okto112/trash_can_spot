class CreateSpotKinds < ActiveRecord::Migration[6.1]
  def change
    create_table :spot_kinds do |t|
      t.bigint :spot_id, null: false
      t.bigint :kind_id, null: false
      t.timestamps
    end

    add_foreign_key :spot_kinds, :spots
    add_foreign_key :spot_kinds, :kinds
  end
end
