class CreateFormStartTimeCollections < ActiveRecord::Migration[6.1]
  def change
    create_table :form_start_time_collections do |t|

      t.timestamps
    end
  end
end
