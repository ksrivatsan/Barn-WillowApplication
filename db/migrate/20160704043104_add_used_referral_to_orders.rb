class AddUsedReferralToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :used_referral, :boolean
  end
end
