require 'json'
require '../lib/get_from_wikipedia'

countries = JSON.parse(IO.read("../../countries.json").force_encoding("UTF-8").encode!)

countries.select! { |c| c["continent"] == "Asia" }

def fetch_country(code, name)
	case code
	# when "AF" # Afghanistan
	# when "BH" # Bahrain
	# when "BD" # Bangladesh
	# when "BT" # Bhutan
	# when "BN" # Brunei Darussalam
	# when "KH" # Cambodia
	when "CN" # China
		tables = [
			TableIndexMap.new(1, 0, 3, 2),
		]
		GetFromWikipedia.Scrape(code, name, tables: tables) do |each_name, prop|
			if prop == :name
				each_name = each_name.split("\n").first.strip
			end
			each_name
		end
	when "HK" # Hong Kong
		return
	when "IN" # India
		tables = [
			TableIndexMap.new(1, 0, 2),
		]
		GetFromWikipedia.Scrape(code, name, tables: tables)
	# when "ID" # Indonesia
	# when "IR" # Iran, Islamic Republic Of
	# when "IQ" # Iraq
	# when "IL" # Israel
	# when "JP" # Japan
	# when "JO" # Jordan
	# when "KP" # Korea, Democratic People's Republic of
	# when "KR" # Korea, Republic of
	# when "KW" # Kuwait
	# when "KG" # Kyrgyzstan
	# when "LA" # Lao People's Democratic Republic
	# when "LB" # Lebanon
	when "MO" # Macao
		return
	when "MY" # Malaysia
		tables = [
			TableIndexMap.new(1, 0, 2),
		]
		GetFromWikipedia.Scrape(code, name, tables: tables)
	# when "MV" # Maldives
	# when "MN" # Mongolia
	# when "MM" # Myanmar
	# when "NP" # Nepal
	# when "OM" # Oman
	# when "PK" # Pakistan
	# when "PS" # Palestinian Territory, Occupied
	# when "PH" # Philippines
	# when "QA" # Qatar
	# when "SA" # Saudi Arabia
	# when "SG" # Singapore
	# when "LK" # Sri Lanka
	# when "SY" # Syrian Arab Republic
	# when "TW" # Taiwan, Province of China
	# when "TJ" # Tajikistan
	# when "TH" # Thailand
	# when "TM" # Turkmenistan
	# when "AE" # United Arab Emirates
	# when "UZ" # Uzbekistan
	# when "VN" # Viet Nam
	# when "YE" # Yemen
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
