class CreateFabrics < ActiveRecord::Migration
  def change
    create_table :fabrics do |t|
      t.string :fabric_type
      t.string :fabric_color
      t.text :fabric_image_url

      t.timestamps null: false
    end
  end
end
