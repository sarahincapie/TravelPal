json.array!(@expenses) do |expense|
  json.extract! expense, :id, :textmsg, :cost, :date, :time, :location, :latitude, :longitude, :user_id
  json.url expense_url(expense, format: :json)
end
