require '../lib/get_from_wikipedia'

GetFromWikipedia.Scrape("VE", "venezuela") do |name|
	name.gsub("Distrito Federal") { |match| "Distrito Capital" }
end
