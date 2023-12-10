class CreateLaneDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :lane_details do |t|
      t.string :name_1, null: false
      t.string :name_2, null: false
      t.string :name_3, null: false
      t.string :name_4
      t.timestamps
    end
  end
end
