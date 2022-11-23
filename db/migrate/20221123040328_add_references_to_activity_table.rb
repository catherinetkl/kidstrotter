class AddReferencesToActivityTable < ActiveRecord::Migration[7.0]
  def change
    add_reference :activities, :category, foreign_key: true
    add_reference :activities, :organizer, foreign_key: true
  end
end
