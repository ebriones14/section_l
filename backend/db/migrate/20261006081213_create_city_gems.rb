class CreateCityGems < ActiveRecord::Migration[7.2]
  def change
    create_table :city_gems do |t|
      t.references :property, null: false, foreign_key: true
      t.string :name, null: false
      t.string :category, null: false
      t.string :short, null: false
      t.string :long, null: false
      t.string :maps, null: false
      t.string :image_url
      t.timestamps
    end
  end
end
