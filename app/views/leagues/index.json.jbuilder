json.array!(@leagues) do |league|
  json.extract! league, :id, :division, :group
  json.url league_url(league, format: :json)
end
