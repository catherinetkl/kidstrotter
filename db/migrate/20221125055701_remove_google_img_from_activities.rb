class RemoveGoogleImgFromActivities < ActiveRecord::Migration[7.0]
  def change
    remove_column :activities, :google_image_url
  end
end
