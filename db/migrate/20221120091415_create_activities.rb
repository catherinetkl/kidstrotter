class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities do |t|
      t.string :name, null: false
      t.text :description
      t.string :location, null: false
      t.float :price, null: false
      t.string :age_group, null: false
      t.float :rating

      t.timestamps
    end
  end
end
