class CreateStartDates < ActiveRecord::Migration[6.1]
  def change
    create_table :start_dates do |t|

      t.date :start_date, null: false
      t.timestamps
    end
  end
end
