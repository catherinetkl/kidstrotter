class AddRequireBookingRequirePaymentAndReferencesToActivityTable < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :require_booking, :boolean, default: false
    add_column :activities, :require_payment, :boolean, default: false
  end
end
