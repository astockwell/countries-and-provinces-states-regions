require 'json'
require 'htmlentities'

# USEAGE:
# require '../utils/html_coding'
# HtmlCoding.Decode(string)

Encoding.default_internal = Encoding::UTF_8
Encoding.default_external = Encoding::UTF_8

module HtmlCoding
	@coder = HTMLEntities.new

	def self.Decode(s)
		@coder.decode(s)
	end
end
