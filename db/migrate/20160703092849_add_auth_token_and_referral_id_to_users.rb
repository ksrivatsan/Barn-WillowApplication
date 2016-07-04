class AddAuthTokenAndReferralIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_token, :string
    add_column :users, :referral_id, :string
  end
end
