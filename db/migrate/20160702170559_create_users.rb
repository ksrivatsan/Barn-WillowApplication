class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email_address
      t.integer :free_credit

      t.timestamps null: false
    end
  end
end
