json.array!(@teams) do |team|
  json.extract! team, :id, :name, :league_id, :captain_id
  json.url team_url(team, format: :json)
end
