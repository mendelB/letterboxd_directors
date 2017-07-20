require 'open-uri'
require 'JSON'

class TmdbAPIClient
	SEARCH_BASE = "https://api.themoviedb.org/3/search/movie"
	API_KEY = "?api_key=#{ENV['API_KEY']}"
	MOVIE_BASE = "https://api.themoviedb.org/3/movie/"
	def self.get_director(movie_name, movie_year)
		url = SEARCH_BASE + API_KEY + "&query=#{movie_name}&year=#{movie_year}"
		puts url
		begin 
			res = open(self.normalize_uri(url))
		rescue
			binding.pry
		end
		json = JSON.parse(res.read)
		result = json["results"][0]
		movie_img_url = "http://image.tmdb.org/t/p/w185/#{result["poster_path"]}" 
		id = result["id"].to_s

		url = MOVIE_BASE + id + API_KEY + "&append_to_response=credits"
		res = open(url)
		json = JSON.parse(res.read)
		directors = json["credits"]["crew"].select { |credit| credit["job"] == "Director"}.map do |director|
			{
				director: {
					name: director["name"],
					img_url: "https://image.tmdb.org/t/p/w185/#{director["profile_path"]}",
				},
				movie: {
					id: id,
					name: movie_name,
					img_url: movie_img_url
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