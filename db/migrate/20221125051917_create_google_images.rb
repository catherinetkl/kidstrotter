class CreateGoogleImages < ActiveRecord::Migration[7.0]
  def change
    create_table :google_images do |t|
      t.string   :url,          null: false
      t.references :activity, foreign_key: true
      t.timestamps
    end
  end
end
