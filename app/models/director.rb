class Director < ApplicationRecord
	has_many :director_films
	has_many :films, through: :director_films
end
