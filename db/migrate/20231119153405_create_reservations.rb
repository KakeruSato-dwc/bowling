class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|

      t.string :group_name, null: false
      t.integer :num_children, null: false, default: 0
      t.integer :num_students, null: false, default: 0
      t.integer :num_adults, null: false, default: 0
      t.integer :num_games, null: false
      t.integer :num_lanes, null: false
      t.date :start_date, null: false
      t.time :start_time, null: false
      t.text :note
      t.integer :games_fee, null: false
      t.boolean :is_active, null: false, default: true
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
