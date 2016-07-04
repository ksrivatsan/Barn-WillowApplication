json.array!(@fabrics) do |fabric|
  json.extract! fabric, :id, :type, :color, :image_url
  json.url fabric_url(fabric, format: :json)
end
