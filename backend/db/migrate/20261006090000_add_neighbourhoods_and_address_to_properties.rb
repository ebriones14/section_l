class AddNeighbourhoodsAndAddressToProperties < ActiveRecord::Migration[8.1]
  def change
    add_column :properties, :address, :string, null: false, default: "Address pending"
    change_column_default :properties, :address, from: "Address pending", to: nil

    create_table :neighbourhoods do |t|
      t.string :name, null: false
      t.string :hashtag
      t.text :hashtag_description
      t.text :description
      t.string :city
      t.string :map_pin
      t.string :tags

      t.timestamps
    end
    add_index :neighbourhoods, :name, unique: true

    create_table :property_neighbourhoods do |t|
      t.references :property, null: false, foreign_key: true
      t.references :neighbourhood, null: false, foreign_key: true

      t.timestamps
    end
    add_index :property_neighbourhoods,
      [ :property_id, :neighbourhood_id ],
      unique: true

    create_table :city_gem_neighbourhoods do |t|
      t.references :city_gem, null: false, foreign_key: true
      t.references :neighbourhood, null: false, foreign_key: true

      t.timestamps
    end
    add_index :city_gem_neighbourhoods,
      [ :city_gem_id, :neighbourhood_id ],
      unique: true
  end
end
