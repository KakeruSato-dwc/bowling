class CreateStartDatetimes < ActiveRecord::Migration[6.1]
  def change
    create_table :start_datetimes do |t|

      t.date :start_date, null: false
      t.time :start_time, null: false
      t.integer :num_available_lanes, null: false
      t.timestamps
    end
  end
end
