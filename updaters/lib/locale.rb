###
# Represents a single province/state/region
#
class Locale < Struct.new(:name, :code, :subdivision, :native)
	def to_map
		map = Hash.new
		self.members.each { |m| map[m] = self[m] unless self[m].nil? }
		map
	end

	def to_json(*a)
		to_map.to_json(*a)
	end

	def <=>(other)
		self[:name] <=> other[:name]
	end
end
