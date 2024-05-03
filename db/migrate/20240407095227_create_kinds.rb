class CreateKinds < ActiveRecord::Migration[6.1]
  def change
    create_table :kinds do |t|
      t.text "name", null: false
      t.text "color", null: false
      t.timestamps
    end
  end
end
