json.array!(@orders) do |order|
  json.extract! order, :id, :name, :email_address, :shipping_address, :order_details, :referred_by
  json.url order_url(order, format: :json)
end
