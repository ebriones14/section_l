class CreateCityGems < ActiveRecord::Migration[7.2]
  def change
    create_table :city_gems do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.string :short, null: false
      t.text :long, null: false
      t.string :maps, null: false
      t.string :image_url
      t.timestamps
    end
  end
end
