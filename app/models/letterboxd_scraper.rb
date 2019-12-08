require 'nokogiri'
require 'open-uri'

class LetterboxdScraper
	def self.attempt(retries = 0, &block)
		begin
			block.call()
		rescue
			p 'rescue'
			sleep(5)
			return nil if retries >= 5
			p "attempt number #{retries}"
			self.attempt(retries + 1, &block)
		end
	end

	def self.scrape_films(user)
		username = user.username

		# Fetch the user's films sorted by date page.
		films_by_date_page = attempt() { Nokogiri::HTML(open("https://letterboxd.com/#{username}/films/by/date")) }
		
		return if !films_by_date_page

		most_recently_logged_film = films_by_date_page.css('.poster-list li div')[0].attributes['data-film-slug'].value

		if most_recently_logged_film === user.last_added
			return user
		else
			user.last_added = most_recently_logged_film
		end

		# Grab the final page number in the pagination list, so we know how many pages to run through.
		# If they've only got one page of films (😢), we'll default to 1 since there won't be pagination.
		last_paginated_page_num = films_by_date_page.css('.pagination ul li')[-1].text.to_i || 1
		
		amount_of_films_per_page = films_by_date_page.css('.poster-list li div').length
		total_logged_film_count = last_paginated_page_num * amount_of_films_per_page
		
		# Keep track of the number of TMDB API calls, so we can rest occasionally,
		# to prevent hitting the throttling max.
		tmdb_api_hit_counter = 0

		last_paginated_page_num.times do |i|
			# Grab the page of films.
			page = attempt() { Nokogiri::HTML(open("https://letterboxd.com/#{username}/films/by/date/page/#{(i + 1).to_s}")) }

			next if !page

			# For each film in the list:
			page.css('.poster-list li div').each.with_index(1) do |poster, index|
				current_film_index = (i * amount_of_films_per_page) + index
				p "Parsing #{current_film_index} of  ~#{total_logged_film_count}"

				film_slug = poster.attributes['data-film-slug'].value

				film = Film.find_by({slug: film_slug})

				if film
					next if user.films.include?(film)
					p "Adding film! Title: #{film.title}"
					user.films << film
				else
					p "Creating film! Slug: #{film_slug}"
					film_page = attempt() { Nokogiri::HTML(open('https://letterboxd.com' + film_slug)) }

					next if !page

					header = film_page.css('#featured-film-header')[0]

					title = header.css('h1').text
					year = header.css('.number').text
					poster_img_url = film_page.css('.film-poster img')[0].attributes['src'].value

					film = Film.find_or_create_by({slug: film_slug})
					film.update({ title: title, year: year, poster_img_url: poster_img_url })
					user.films << film

					# Grab the list of directors.
					director_nodes = header.css('a[href^="/director/"]')

					director_nodes.each do |director_node|
						director_name = director_node.text
						director_img_url = TmdbAPIClient.get_director(director_name)

						director = Director.find_or_create_by({name: director_name})
						director.img_url = director_img_url
						director.films << film
						director.save
					end

					tmdb_api_hit_counter += 1
					sleep(10) && tmdb_api_hit_counter = 0 if tmdb_api_hit_counter >= 50
				end
			end
		end

		user.save
		return user
	end
end