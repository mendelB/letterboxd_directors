class Director < ApplicationRecord
	has_many :director_films
	has_many :films, through: :director_films

	def user_films(user)
		films.where(id: user.films)
	end
end
