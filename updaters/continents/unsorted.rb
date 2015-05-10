require 'json'
require '../lib/get_from_wikipedia'

countries = JSON.parse(IO.read("../../countries.json").force_encoding("UTF-8").encode!)

countries.reject! { |c| c["continent"] }

def fetch_country(code, name)
	case code
	when "AX" # Aland Islands
		return
	when "AQ" # Antarctica
		return
	when "BV" # Bouvet Island
		return
	when "IO" # British Indian Ocean Territory
		return
	when "CK" # Cook Islands
		return
	when "FO" # Faroe Islands
		return
	when "TF" # French Southern Territories
		return
	when "GI" # Gibraltar
		return
	when "GG" # Guernsey
		return
	when "HM" # Heard Island and Mcdonald Islands
		return
	when "IM" # Isle of Man
		return
	when "JE" # Jersey
		return
	when "NU" # Niue
		return
	when "MP" # Northern Mariana Islands
		return
	when "PN" # Pitcairn
		return
	when "SJ" # Svalbard and Jan Mayen
		return
	when "TK" # Tokelau
		return
	when "WF" # Wallis and Futuna
		return
	when "EH" # Western Sahara
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
