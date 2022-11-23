class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.string :status, default: "pending"
      t.references :activity, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
