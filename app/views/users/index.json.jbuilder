json.array!(@users) do |user|
  json.extract! user, :id, :name, :email_address, :free_credit
  json.url user_url(user, format: :json)
end
