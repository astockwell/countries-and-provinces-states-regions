require 'json'
require '../lib/get_from_wikipedia'

countries = JSON.parse(IO.read("../../countries.json").force_encoding("UTF-8").encode!)

countries.select! { |c| c["continent"] == "North America" }

def fetch_country(code, name)
	case code
	when "AI" # "Anguilla"
		return
	# when "AG" # "Antigua and Barbuda"
	# when "BS" # "Bahamas"
	# when "BB" # "Barbados"
	# when "BZ" # "Belize"
	when "BM" # "Bermuda"
		return
	when "CA" # "Canada"
		tables = [
			TableIndexMap.new(1, 0, 3, 2)
		]
		GetFromWikipedia.Scrape(code, name, tables: tables)
	when "KY" # "Cayman Islands"
		return
	# when "CR" # "Costa Rica"
	# when "CU" # "Cuba"
	# when "DM" # "Dominica"
	# when "DO" # "Dominican Republic"
	# when "SV" # "El Salvador"
	# when "GL" # "Greenland"
	# when "GD" # "Grenada"
	when "GP" # "Guadeloupe"
		return
	# when "GT" # "Guatemala"
	# when "HT" # "Haiti"
	# when "HN" # "Honduras"
	# when "JM" # "Jamaica"
	when "MQ" # "Martinique"
		return
	when "MX" # "Mexico"
		tables = [
			TableIndexMap.new(1, 0, 2)
		]
		GetFromWikipedia.Scrape(code, name, tables: tables)
	when "MS" # "Montserrat"
		return
	# when "NI" # "Nicaragua"
	# when "PA" # "Panama"
	when "PR" # "Puerto Rico"
		return
	# when "KN" # "Saint Kitts and Nevis"
	# when "LC" # "Saint Lucia"
	when "PM" # "Saint Pierre and Miquelon"
		return
	# when "VC" # "Saint Vincent and the Grenadines"
	# when "TT" # "Trinidad and Tobago"
	when "TC" # "Turks and Caicos Islands"
		return
	# when "UM" # "United States Minor Outlying Islands"
	when "US" # "United States"
		tables = [
			TableIndexMap.new(1, 0, 2)
		]
		GetFromWikipedia.Scrape(code, name, tables: tables)
	when "VG" # "Virgin Islands, British"
		return
	when "VI" # "Virgin Islands, U.S."
		return
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
