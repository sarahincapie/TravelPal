json.array!(@friends) do |friend|
  json.extract! friend, :id
  json.url friend_url(friend, format: :json)
end
