require 'json'
require 'open-uri'
require 'nokogiri'
require '../lib/locale'

# TODO: Get a better source than wikipedia
@SOURCE = 'http://en.wikipedia.org/wiki/ISO_3166-2:VE'
@results = []

doc = Nokogiri::HTML( open(@SOURCE) )

def custom_processing(s)
	s.gsub("Distrito Federal") { |match| "Distrito Capital" }
end

doc.xpath('//*[@id="mw-content-text"]/table[1]//tr').each do |tr|
	tds = tr.xpath('td[position() >= 1 and not(position() > 2)]/*[not(contains(@class, "sortkey"))]')
	unless tds.size < 2
		name = custom_processing( tds[1].text )
		code = tds[0].text
		@results << Locale.new(name, code)
	end
end

File.open( '../../countries/venezuela.json', 'w' ) do |writer|
	writer.write( JSON.pretty_generate(@results.sort(), indent: "\t") )
end

