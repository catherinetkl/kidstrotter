class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.string :status
      t.references :activities, foreign_key: true
      t.references :users, foreign_key: true
      t.timestamps
    end
  end
end
