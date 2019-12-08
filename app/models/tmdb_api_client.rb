require 'open-uri'
require 'JSON'

class TmdbAPIClient
	SEARCH_BASE = "https://api.themoviedb.org/3/search/movie"
	SEARCH_PERSON_BASE = "https://api.themoviedb.org/3/search/person"
	API_KEY = "?api_key=#{ENV['API_KEY']}"
	MOVIE_BASE = "https://api.themoviedb.org/3/movie/"

	def self.get_director(director_name)
		url = SEARCH_PERSON_BASE + API_KEY + "&query=#{director_name}"

		begin 
			res = open(self.normalize_uri(url))
		rescue
			binding.pry
		end
		json = JSON.parse(res.read)

		return if !json

		result = (json["results"] || []).select do |result| 
			result['name'] === director_name
		end[0]

		return nil if !result || !result["profile_path"]

		return "https://image.tmdb.org/t/p/w185/#{result["profile_path"]}"
	end

	def self.get_directors(movie_name, movie_year)
		url = SEARCH_BASE + API_KEY + "&query=#{movie_name}&year=#{movie_year}"
		puts url
		begin 
			res = open(self.normalize_uri(url))
		rescue
			binding.pry
		end
		json = JSON.parse(res.read)

		return if !json

		result = (json["results"] || []).select do |result| 
			result['title'] === movie_name && result['release_date'].to_i.to_s === movie_year
		end.sort_by do |result|
			result['vote_count']
		end[0]

		return [] if !result 

		movie_img_url = "http://image.tmdb.org/t/p/w185/#{result["poster_path"]}" 
		id = result["id"].to_s

		url = MOVIE_BASE + id + API_KEY + "&append_to_response=credits"
		res = open(url)
		return [] if !res
		json = JSON.parse(res.read)

		return [] if !res

		directors = (json.dig("credits", "crew") || []).select { |credit| credit["job"] == "Director"}.map do |director|
			{
				director: {
					name: director["name"],
					img_url: "https://image.tmdb.org/t/p/w185/#{director["profile_path"]}",
				},
				movie: {
					tmdb_id: id,
					title: movie_name,
					poster_img_url: movie_img_url,
					year: movie_year
				}
			}
		end
	end

	def self.normalize_uri(uri)
  		return uri if uri.is_a? URI

  		uri = uri.to_s
  		uri, *tail = uri.rpartition "#" if uri["#"]

  		URI(URI.encode(uri) << Array(tail).join)
	end
end