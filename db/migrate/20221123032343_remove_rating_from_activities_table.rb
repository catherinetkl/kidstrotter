class RemoveRatingFromActivitiesTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :activities, :rating
  end
end
