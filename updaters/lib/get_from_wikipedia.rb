require 'json'
require 'open-uri'
require 'active_support'
require 'active_support/core_ext/string'
require 'nokogiri'
require_relative '../lib/locale'

TableIndexMap = Locale # :name, :code, :subdivision, :native

# TODO: Get a better source than wikipedia
module GetFromWikipedia
	SOURCE_TMPL = "http://en.wikipedia.org/wiki/ISO_3166-2:%s"
	TABLE_SEARCH_TMPL = "//table[contains(@class, 'wikitable')][%d]"
	EXCLUDED_TAGS = [".sortkey", ".flagicon", ".image"]

	def self.Scrape(code, filename, options={}, &block)
		@tables = options[:tables] || [TableIndexMap.new(1, 0)]

		@results = []

		doc = Nokogiri::HTML( open(SOURCE_TMPL % code) )

		@tables.each_with_index do |table_indices, index|
			next unless table_indices

			one_based_index = index + 1
			table = doc.search( TABLE_SEARCH_TMPL % one_based_index )

			rows = table.css('tr')

			rows.shift # remove table header row

			rows.each do |row|
				tds = row.search('td')

				EXCLUDED_TAGS.each do |tag|
					tds.css(tag).remove
				end

				loc = Locale.new

				loc.members.each do |prop|
					if table_indices[prop]
						if table_indices[prop].is_a? Integer
							if tds[table_indices[prop]] and !tds[table_indices[prop]].content.empty?
								loc[prop] = tds[table_indices[prop]].content
							end
						else
							loc[prop] = table_indices[prop]
						end
					end

					loc[prop] = preprocess(loc[prop]) if loc[prop]
					loc[prop] = yield(loc[prop], prop) if loc[prop] and block_given?

					loc[prop] = nil if loc[prop] == ""
				end

				# p loc
				@results << loc
			end

		end

		if @results.size < 1
			puts "No results for #{filename}, no json file written"
			return
		end

		File.open( "../../countries/#{filename}.json", 'w' ) do |writer|
			writer.write( JSON.pretty_generate(@results.sort_by{ |r| [r.subdivision, r.name] }, indent: "\t") )
		end
	end

	def self.preprocess(s)
		s = s.gsub(" ") { |match| "" } # remove magical 0x2022 character
		s = s.gsub(/\[.*?\]/) { |match| "" } # remove braces
		s = s.gsub(/\(.*?\)/) { |match| "" } # remove parentheses
		return s.strip
	end

	def self.make_filename(s)
		s.gsub(/\(.*?\)/){ |m| "" }.parameterize
	end
end
