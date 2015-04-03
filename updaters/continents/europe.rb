require 'json'
require 'active_support'
require 'active_support/core_ext/string'
require '../lib/get_from_wikipedia'

countries = JSON.parse(IO.read("../../countries.json").force_encoding("UTF-8").encode!)

countries.select! { |c| c["continent"] == "Europe" }

def populate_gb(code, name)
	source = "http://en.wikipedia.org/wiki/ISO_3166-2:#{code}"
	results = []
	preprocess = ->(s) {
		s = s.gsub(" ") { |match| "" } # remove magical 0x2022 character
		s = s.gsub(/\[.*?\]/) { |match| "" } # remove braces
		return s.strip
	}

	doc = Nokogiri::HTML( open(source) )

	# Countries and province
	doc.xpath('//*[@id="mw-content-text"]/table[1]//tr').each do |tr|
		tds = tr.xpath('td')
		unless tds.size < 2
			begin
				n = preprocess.call(tds[1].text)
				c = tds[0].text
				t = preprocess.call(tds[2].text)
				results << Locale.new(n, c, t)
				rescue Exception => e
				puts "Error encountered parsing tds (#{tds}) into Locale: #{e}"
			end
		end
	end

	# Nations
	doc.xpath('//*[@id="mw-content-text"]/table[2]//tr').each do |tr|
		tds = tr.xpath('td')
		unless tds.size < 2
			begin
				n = preprocess.call(tds[1].text)
				c = tds[0].text
				t = "nation"
				results << Locale.new(n, c, t)
				rescue Exception => e
				puts "Error encountered parsing tds (#{tds}) into Locale: #{e}"
			end
		end
	end

	# Second-level subdivisions
	doc.xpath('//*[@id="mw-content-text"]/table[3]//tr').each do |tr|
		tds = tr.xpath('td')
		unless tds.size < 2
			begin
				n = preprocess.call(tds[1].text)
				c = tds[0].text
				t = preprocess.call(tds[2].text)
				results << Locale.new(n, c, t)
				rescue Exception => e
				puts "Error encountered parsing tds (#{tds}) into Locale: #{e}"
			end
		end
	end

	File.open( "../../countries/#{name}.json", 'w' ) do |writer|
		writer.write( JSON.pretty_generate(results.sort_by{ |r| [r.subdivision, r.name] }, indent: "\t") )
	end
end

def fetch_country(code, name)
	case code
	# when "AL" # Albania
	# when "AD" # AndorrA
	# when "AM" # Armenia
	# when "AT" # Austria
	# when "AZ" # Azerbaijan
	# when "BY" # Belarus
	# when "BE" # Belgium
	# when "BA" # Bosnia and Herzegovina
	# when "BG" # Bulgaria
	# when "HR" # Croatia
	# when "CY" # Cyprus
	# when "CZ" # Czech Republic
	# when "DK" # Denmark
	# when "EE" # Estonia
	# when "FI" # Finland
	# when "FR" # France
	# when "GE" # Georgia
	# when "DE" # Germany
	# when "GR" # Greece
	when "VA" # Holy See (Vatican City State)
		return
	# when "HU" # Hungary
	# when "IS" # Iceland
	# when "IE" # Ireland
	# when "IT" # Italy
	# when "KZ" # Kazakhstan
	# when "LV" # Latvia
	# when "LI" # Liechtenstein
	# when "LT" # Lithuania
	# when "LU" # Luxembourg
	# when "MK" # Macedonia, The Former Yugoslav Republic of
	# when "MT" # Malta
	# when "MD" # Moldova, Republic of
	# when "MC" # Monaco
	# when "ME" # Montenegro
	# when "NL" # Netherlands
	when "AN" # Netherlands Antilles
		return
	# when "NO" # Norway
	# when "PL" # Poland
	# when "PT" # Portugal
	# when "RO" # Romania
	# when "RU" # Russian Federation
	# when "SM" # San Marino
	# when "RS" # Serbia
	# when "SK" # Slovakia
	# when "SI" # Slovenia
	when "GS" # South Georgia and the South Sandwich Islands
		return
	# when "ES" # Spain
	# when "SE" # Sweden
	# when "CH" # Switzerland
	# when "TR" # Turkey
	# when "UA" # Ukraine
	when "GB" # United Kingdom
		populate_gb(code, name)
	else
		GetFromWikipedia.Scrape(code, name)
	end
	p code + " - " + name
end

countries.each do |country|
	n = country["name"].gsub(/\(.*?\)/){ |m| "" }.parameterize
	c = country["code"]

	fetch_country(c, n)
end
