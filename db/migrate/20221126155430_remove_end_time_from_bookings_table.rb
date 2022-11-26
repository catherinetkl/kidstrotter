class RemoveEndTimeFromBookingsTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :bookings, :end_time
  end
end
