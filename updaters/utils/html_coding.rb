require 'json'
require 'htmlentities'

Encoding.default_internal = Encoding::UTF_8
Encoding.default_external = Encoding::UTF_8

@coder = HTMLEntities.new

states = JSON.parse( File.read('../../countries/thailand.json') )

states.each do |s|
	p @coder.decode s['name']
end
