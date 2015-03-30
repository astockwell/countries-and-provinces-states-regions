require 'json'
require 'open-uri'
require 'nokogiri'
require_relative 'locale'

# TODO: Get a better source than wikipedia
module GetFromWikipedia
	def self.Scrape(code, filename)
		@SOURCE = "http://en.wikipedia.org/wiki/ISO_3166-2:#{code}"
		@results = []

		doc = Nokogiri::HTML( open(@SOURCE) )

		doc.xpath('//*[@id="mw-content-text"]/table[1]//tr').each do |tr|
			tds = tr.xpath('td[position() >= 1 and not(position() > 2)]/*[not(contains(@class, "sortkey"))]')
			unless tds.size < 2
				name = block_given? ? yield( tds[1].text ) : tds[1].text
				code = tds[0].text
				@results << Locale.new(name, code)
			end
		end

		File.open( "../../countries/#{filename}.json", 'w' ) do |writer|
			writer.write( JSON.pretty_generate(@results.sort(), indent: "\t") )
		end
	end
end
