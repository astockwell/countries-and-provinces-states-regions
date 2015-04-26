require 'json'
require '../lib/get_from_wikipedia'

countries = JSON.parse(IO.read("../../countries.json").force_encoding("UTF-8").encode!)

countries.select! { |c| c["continent"] == "Oceania" }

def fetch_country(code, name)
	case code
	when "AS" # american-samoa
		return
	# when "AU" # australia
	when "CX" # christmas-island
		return
	when "CC" # cocos-keeling-islands
		return
	# when "FJ" # fiji
	when "GU" # guam
		return
	when "PF" # french-polynesia
		return
	# when "KI" # kiribati
	# when "MH" # marshall-islands
	# when "FM" # micronesia-federated-states-of
	# when "NR" # nauru
	when "NC" # new-caledonia
		return
	when "NZ" # new-zealand
		GetFromWikipedia.Scrape(code, name, tables: [
			TableIndexMap.new(1, 0, "Island"),
			TableIndexMap.new(1, 0, 3, 2),
		])
	when "NF" # norfolk-island
		return
	# when "PW" # palau
	# when "PG" # papua-new-guinea
	# when "WS" # samoa
	# when "SB" # solomon-islands
	# when "TL" # timor-leste
	# when "TO" # tonga
	# when "TV" # tuvalu
	# when "VU" # vanuatu
	else
		GetFromWikipedia.Scrape(code, name)
	end
	p code + " - " + name
end

countries.each do |country|
	n = GetFromWikipedia.make_filename(country["name"])
	c = country["code"]

	fetch_country(c, n)
end
