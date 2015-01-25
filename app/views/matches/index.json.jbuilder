json.array!(@matches) do |match|
  json.extract! match, :id, :home_score, :visitor_score, :date
  json.url match_url(match, format: :json)
end
