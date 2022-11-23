class CreateAgeGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :age_groups do |t|
      t.string :name

      t.timestamps
    end

    create_join_table :activities, :age_groups
  end
end
