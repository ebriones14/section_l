class AddTagsToCityGems < ActiveRecord::Migration[8.1]
  def change
    add_column :city_gems, :tags, :string, array: true, default: [], null: false
  end
end
