require 'json'
require '../lib/get_from_wikipedia'

countries = JSON.parse(IO.read("../../countries.json").force_encoding("UTF-8").encode!)

countries.select! { |c| c["continent"] == "Africa" }

def fetch_country(code, name)
	case code
	# when "DZ" # Algeria
	# when "AO" # Angola
	# when "BJ" # Benin
	# when "BW" # Botswana
	# when "BF" # Burkina Faso
	# when "BI" # Burundi
	# when "CM" # Cameroon
	# when "CV" # Cape Verde
	# when "CF" # Central African Republic
	# when "TD" # Chad
	# when "KM" # Comoros
	# when "CG" # Congo
	# when "CD" # Congo, The Democratic Republic of the
	# when "CI" # Cote d'Ivoire, Republic of
	# when "DJ" # Djibouti
	# when "EG" # Egypt
	# when "GQ" # Equatorial Guinea
	# when "ER" # Eritrea
	# when "ET" # Ethiopia
	# when "GA" # Gabon
	# when "GM" # Gambia
	# when "GH" # Ghana
	# when "GN" # Guinea
	# when "GW" # Guinea-Bissau
	# when "KE" # Kenya
	# when "LS" # Lesotho
	# when "LR" # Liberia
	# when "LY" # Libyan Arab Jamahiriya
	# when "MG" # Madagascar
	# when "MW" # Malawi
	# when "ML" # Mali
	# when "MR" # Mauritania
	# when "MU" # Mauritius
	when "YT" # Mayotte
		return
	# when "MA" # Morocco
	# when "MZ" # Mozambique
	# when "NA" # Namibia
	# when "NE" # Niger
	# when "NG" # Nigeria
	when "RE" # Reunion
		return
	# when "RW" # Rwanda
	# when "SH" # Saint Helena, Ascension and Tristan da Cunha
	# when "ST" # Sao Tome and Principe
	# when "SN" # Senegal
	# when "SC" # Seychelles
	# when "SL" # Sierra Leone
	# when "SO" # Somalia
	# when "ZA" # South Africa
	# when "SS" # South Sudan
	# when "SD" # Sudan
	# when "SZ" # Swaziland
	# when "TZ" # Tanzania, United Republic of
	# when "TG" # Togo
	# when "TN" # Tunisia
	# when "UG" # Uganda
	# when "ZM" # Zambia
	# when "ZW" # Zimbabwe
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
