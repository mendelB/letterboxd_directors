require 'csv'
class CSVHandler
	def self.handle(csv, unread=true)
		if unread
			data = CSV.read(csv.path)
			session_id = csv.tempfile
			SessionCsv.create({csv: data, session_id: session_id})
		else 
			data = csv
		end
		headers = data[0]
		body = data[1..-1]
		directors = Hash.new { |hash, key| hash[key] = [] }
		api_hit_counter = 0
		body.each_slice(20) do |rows|
			rows.each do |row|
				name = row[headers.index('Name')]
				year = row[headers.index('Year')]
				film = Film.find_by({title: name, year: year})
				if film && film.directors.length > 0
					film.directors.each do |director|
						directors[director] << film
					end
				else
					result = TmdbAPIClient.get_director(name, year)
					result.each do |r|
						film = Film.find_or_create_by r[:movie]
						director = Director.find_or_create_by r[:director]
						directors[director] << film
						director.films << film
						director.save
					end
					sleep(10) && api_hit_counter = 0 if api_hit_counter >= 20 && body.length > 20
				end
			end
		end
		return directors.sort_by { |director, films| films.length }.reverse
	end
end