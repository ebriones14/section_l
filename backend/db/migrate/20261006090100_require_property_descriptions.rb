class RequirePropertyDescriptions < ActiveRecord::Migration[8.1]
  def change
    change_column_null :properties, :description, false, "Description pending"
  end
end
