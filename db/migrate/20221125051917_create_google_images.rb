class CreateGoogleImages < ActiveRecord::Migration[7.0]
  def change
    create_table :google_images do |t|

      t.timestamps
    end
  end
end
