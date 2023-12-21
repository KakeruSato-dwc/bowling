class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.integer :valuation, null: false
      t.text :body
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
