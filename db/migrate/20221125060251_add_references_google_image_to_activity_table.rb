class AddReferencesGoogleImageToActivityTable < ActiveRecord::Migration[7.0]
  def change
    add_reference :activities, :google_image, foreign_key: true
  end
end
