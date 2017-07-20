require 'csv'
class CSVHandler
	def self.handle(csv)
		data = CSV.read(csv.path)
		headers = data[0]
		body = data[1..-1]
		directors = Hash.new { |hash, key| hash[key] = [] }
		body.each_slice(20) do |rows|
			rows.each do |row|
				name = row[headers.index('Name')]
				year = row[headers.index('Year')]
				result = TmdbAPIClient.get_director(name, year)
				result.each do |r|
					directors[r[:director]] << r[:movie]
				end
			end
			next if body.length <= 20
			sleep(10)
		end
		return directors
	end
end