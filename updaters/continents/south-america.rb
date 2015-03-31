require 'json'
require 'active_support'
require 'active_support/core_ext/string'
require '../lib/get_from_wikipedia'

# raise "Doesn't work, just for future reference..."

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

	# when "SR" # suriname

	# when "UY" # uruguay

	when "VE" # venezuela
		GetFromWikipedia.Scrape(code, name) do |each_name|
			each_name.gsub("Distrito Federal") { |match| "Distrito Capital" }
		end
	else
		GetFromWikipedia.Scrape(code, name)
	end
end

countries.each do |country|
	n = country["name"].gsub(/\(.*?\)/){ |m| "" }.parameterize
	c = country["code"]

	fetch_country(c, n)
end
