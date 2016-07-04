class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.string :email_address
      t.string :shipping_address
      t.text :order_details
      t.integer :referred_by

      t.timestamps null: false
    end
  end
end
