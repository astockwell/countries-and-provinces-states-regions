require 'json'
require '../lib/get_from_wikipedia'

countries = JSON.parse(IO.read("../../countries.json").force_encoding("UTF-8").encode!)

countries.select! { |c| c["continent"] == "South America" }

def fetch_country(code, name)
	case code
	# when "AR" # argentina
	# when "BO" # bolivia
	# when "BR" # brazil
	# when "CL" # chile
	# when "CO" # colombia
	# when "EC" # ecuador
	when "FK" # falkland-islands
		return
	when "GF" # french-guiana
		return
	# when "GY" # guyana
	# when "PY" # paraguay
	# when "PE" # peru
	when "GS" # South Georgia and the South Sandwich Islands
		return
	# when "SR" # suriname
	# when "UY" # uruguay
	when "VE" # venezuela
		GetFromWikipedia.Scrape(code, name) do |each_name|
			each_name.gsub("Distrito Federal") { |match| "Distrito Capital" }
		end
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
