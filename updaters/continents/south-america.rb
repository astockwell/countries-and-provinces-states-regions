require 'json'
require 'active_support'
require 'active_support/core_ext/string'
require '../lib/get_from_wikipedia'

raise "Doesn't work, just for future reference..."

countries = JSON.parse(IO.read("../../countries.json").force_encoding("UTF-8").encode!)

countries.select! { |c| c["continent"] == "South America" }

countries.each do |country|
	name = country["name"].gsub(/\(.*?\)/){ |m| "" }.parameterize
	code = country["code"]

	GetFromWikipedia.Scrape(code, name)
end
