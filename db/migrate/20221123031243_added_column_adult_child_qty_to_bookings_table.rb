class AddedColumnAdultChildQtyToBookingsTable < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :adult_qty, :integer, default: 0, null: false
    add_column :bookings, :child_qty, :integer, default: 0, null: false
  end
end
