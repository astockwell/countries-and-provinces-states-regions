require 'json'
require 'open-uri'
require 'nokogiri'
require_relative 'locale'

# TODO: Get a better source than wikipedia
module GetFromWikipedia
	def self.Scrape(code, filename, options={})
		starting_xpath = options[:starting_xpath] || '//*[@id="mw-content-text"]/table[1]//tr'
		nested_xpath = options[:nested_xpath] || 'td[position() >= 1 and not(position() > 2)]/*[not(contains(@class, "sortkey") or contains(@class, "flagicon") or contains(@class, "image"))]'
		code_td_index = options[:code_td_index] || 0
		name_td_index = options[:name_td_index] || 1

		@SOURCE = "http://en.wikipedia.org/wiki/ISO_3166-2:#{code}"
		@results = []

		doc = Nokogiri::HTML( open(@SOURCE) )

		doc.xpath(starting_xpath).each do |tr|
			tds = tr.xpath(nested_xpath)
			unless tds.size < 2
				begin
					name = preprocess(tds[name_td_index].text)
					name = yield(name) if block_given?
					code = tds[code_td_index].text
					@results << Locale.new(name, code)
 				rescue Exception => e
					puts "Error encountered parsing tds (#{tds}) into Locale: #{e}"
				end
			end
		end

		File.open( "../../countries/#{filename}.json", 'w' ) do |writer|
			writer.write( JSON.pretty_generate(@results.sort_by{ |r| [r.subdivision, r.name] }, indent: "\t") )
		end
	end

	def self.preprocess(s)
		s = s.gsub(" ") { |match| "" } # remove magical 0x2022 character
		return s.strip
	end
end
