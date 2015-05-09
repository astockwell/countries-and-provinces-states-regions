require 'json'
require '../lib/get_from_wikipedia'

countries = JSON.parse(IO.read("../../countries.json").force_encoding("UTF-8").encode!)

countries.select! { |c| c["continent"] == "Europe" }

def fetch_country(code, name)
	case code
	# when "AL" # Albania
	# when "AD" # AndorrA
	# when "AM" # Armenia
	# when "AT" # Austria
	when "AW" # Aruba
		return
	# when "AZ" # Azerbaijan
	# when "BY" # Belarus
	when "BE" # Belgium
		GetFromWikipedia.Scrape(code, name) do |each_name, prop|
			if prop == :name
				each_name = each_name.split("\n").first.strip
			end
			each_name
		end
	# when "BA" # Bosnia and Herzegovina
	# when "BG" # Bulgaria
	# when "HR" # Croatia
	when "CW" # Curacao
		return
	# when "CY" # Cyprus
	# when "CZ" # Czech Republic
	# when "DK" # Denmark
	# when "EE" # Estonia
	# when "FI" # Finland
	when "FR" # France
		tables = [
			TableIndexMap.new(2, 0, "Metropolitan region", 1),
		]
		GetFromWikipedia.Scrape(code, name, tables: tables)
	# when "GE" # Georgia
	# when "DE" # Germany
	# when "GR" # Greece
	when "VA" # Holy See (Vatican City State)
		return
	# when "HU" # Hungary
	# when "IS" # Iceland
	# when "IE" # Ireland
	when "IT" # Italy
		GetFromWikipedia.Scrape(code, name) do |each_name, prop|
			if prop == :name
				each_name = each_name.split(',').first.strip
			end
			each_name
		end
	# when "KZ" # Kazakhstan
	# when "LV" # Latvia
	# when "LI" # Liechtenstein
	# when "LT" # Lithuania
	when "LU" # Luxembourg
		GetFromWikipedia.Scrape(code, name) do |each_name, prop|
			if prop == :name
				each_name = each_name.split(',').first.strip
			end
			each_name
		end
	# when "MK" # Macedonia, The Former Yugoslav Republic of
	when "MT" # Malta
		GetFromWikipedia.Scrape(code, name) do |each_name, prop|
			if prop == :name
				each_name = each_name.split(',').first.strip
			end
			each_name
		end
	# when "MD" # Moldova, Republic of
	# when "MC" # Monaco
	# when "ME" # Montenegro
	when "NL" # Netherlands
		tables = [
			TableIndexMap.new(1, 0, "Province"),
			TableIndexMap.new(1, 0, 2),
		]
		GetFromWikipedia.Scrape(code, name, tables: tables)
	when "AN" # Netherlands Antilles
		return
	# when "NO" # Norway
	# when "PL" # Poland
	# when "PT" # Portugal
	# when "RO" # Romania
	when "RU" # Russian Federation
		tables = [
			TableIndexMap.new(1, 0, 3, 2),
		]
		GetFromWikipedia.Scrape(code, name, tables: tables)
	# when "SM" # San Marino
	# when "RS" # Serbia
	# when "SK" # Slovakia
	# when "SI" # Slovenia
	when "ES" # Spain
		tables = [
			TableIndexMap.new(1, 0, 2),
			TableIndexMap.new(1, 0, "Province"),
		]
		GetFromWikipedia.Scrape(code, name, tables: tables) do |each_name, prop|
			if prop == :name
				each_name = each_name.split('/').first.strip
			end
			each_name
		end
	# when "SE" # Sweden
	when "CH" # Switzerland
		GetFromWikipedia.Scrape(code, name) do |each_name, prop|
			if prop == :name
				each_name = each_name.split(',').first.strip
			end
			each_name
		end
	when "SX" # Sint Maarten
		return
	# when "TR" # Turkey
	# when "UA" # Ukraine
	when "GB" # United Kingdom
		tables = [
			TableIndexMap.new(1, 0, 2),
			TableIndexMap.new(1, 0, "Nation"),
			TableIndexMap.new(1, 0, 2),
		]
		GetFromWikipedia.Scrape(code, name, tables: tables)
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
