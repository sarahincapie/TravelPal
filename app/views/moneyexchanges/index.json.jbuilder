json.array!(@moneyexchanges) do |moneyexchange|
  json.extract! moneyexchange, :id, :money
  json.url moneyexchange_url(moneyexchange, format: :json)
end
