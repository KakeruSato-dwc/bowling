class CreateStartTimes < ActiveRecord::Migration[6.1]
  def change
    create_table :start_times do |t|

      t.time :start_time, null: false
      t.integer :num_available_lanes, null: false, default: 24
      t.integer :start_date_id, null: false
      t.timestamps
    end
  end
end
