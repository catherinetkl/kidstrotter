class AddGoogleImageUrlToActivity < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :google_image_url, :string
  end
end
