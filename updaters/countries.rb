require 'json'
require_relative 'lib/get_from_wikipedia'

module Countries
	def self.update_file_refs
		countries = JSON.parse(IO.read("../countries.json").force_encoding("UTF-8").encode!)

		# Remove filenames
		countries.each do |c|
			c.delete_if { |key, val| key == 'filename' }
		end

		country_files = Dir.glob("../countries/*.json").map { |f| File.basename(f, ".json") }

		# Add filenames
		countries.each do |c|
			target_filename = GetFromWikipedia.make_filename(c['name'])
			c['filename'] = target_filename if country_files.include? target_filename
		end

		File.open("../countries.json", 'w') do |writer|
			writer.write( JSON.pretty_generate(countries.sort_by{ |c| GetFromWikipedia.make_filename(c['name']) }, indent: "\t") )
		end
	end
end

Countries.update_file_refs()
