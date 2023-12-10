class CreateLaneDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :lane_details do |t|
      t.string :name_1
      t.string :name_2
      t.string :name_3
      t.string :name_4
      t.integer :reservation_id
      t.timestamps
    end
  end
end
