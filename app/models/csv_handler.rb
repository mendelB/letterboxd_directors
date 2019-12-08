require 'csv'

class CSVHandler
	def self.handle(csv)
		data = CSV.read(csv.path)
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
					result = TmdbAPIClient.get_directors(name, year)
					result.each do |r|
						film = Film.find_or_create_by r[:movie]
						director = Director.find_or_create_by({name: r[:director][:name]})
						director.update r[:director]
						directors[director] << film
						director.films << film
						director.save
					end
					api_hit_counter += 1
					sleep(10) && api_hit_counter = 0 if api_hit_counter >= 20 && body.length > 20
				end
			end
		end
		return directors.sort_by { |director, films| films.length }.reverse
	end

	# def self.scrape(username)
	# 	doc = self.attempt() { Nokogiri::HTML(open("https://letterboxd.com/#{username}/films/")) }

	# 	final = doc.css('.pagination ul li')[-1]
	# 	final_page_num = final ? final.text.to_i : 1

	# 	directors = Hash.new { |hash, key| hash[key] = [] }
	# 	api_hit_counter = 0

	# 	final_page_num.times do |i|
	# 		page = self.attempt() { Nokogiri::HTML(open("https://letterboxd.com/#{username}/films/page/#{(i + 1).to_s}")) }
	# 		page.css('.poster-list li div').each do |poster|
	# 			slug = poster.attributes['data-film-slug'].value
	# 			p slug

	# 			film = Film.find_by({slug: slug})

	# 			if film && film.directors.length > 0
	# 				p 'skip'
	# 				film.directors.each do |director|
	# 					directors[director] << film
	# 				end
	# 			else
	# 				p 'create'
	# 				film_page = self.attempt() { Nokogiri::HTML(open('https://letterboxd.com' + slug)) }

	# 				header = film_page.css('#featured-film-header')[0]
	# 				name = header.css('h1').text
	# 				year = header.css('.number').text



	# 				result = TmdbAPIClient.get_directors(name, year)

	# 				if result.length <= 0
	# 					puts "FAILURE #{name}"
	# 					next
	# 				end
	# 				film = Film.find_or_create_by({slug: slug}.merge(result[0][:movie]))

	# 				result.each do |r|
	# 					director = Director.find_or_create_by({name: r[:director][:name]})
	# 					director.update r[:director]
	# 					directors[director] << film
	# 					director.films << film
	# 					director.save
	# 				end
	# 				api_hit_counter += 1
	# 				sleep(10) && api_hit_counter = 0 if api_hit_counter >= 50
	# 			end
	# 		end
	# 	end
	# 	return directors.sort_by { |director, films| films.length }.reverse
	# end
end