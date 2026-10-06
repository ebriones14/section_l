class CreateProperties < ActiveRecord::Migration[7.2]
  def change
    create_table :properties do |t|
      t.string :name, null: false
      t.string :city, null: false
      t.string :slug, null: false
      t.text :description
      t.string :hero_image_url

      t.timestamps
    end

    add_index :properties, :slug, unique: true
  end
end
