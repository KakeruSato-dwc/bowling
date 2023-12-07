class CreateStartDates < ActiveRecord::Migration[6.1]
  def change
    create_table :start_dates do |t|

      t.date :start_date, null: false
      t.boolean :is_active, null: false, default: true
      t.timestamps
    end
  end
end
