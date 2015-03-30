require '../lib/get_from_wikipedia'

filename = File.basename(__FILE__, ".rb")

GetFromWikipedia.Scrape("VE", filename) do |name|
	name.gsub("Distrito Federal") { |match| "Distrito Capital" }
end
