class Film < ApplicationRecord
	has_many :director_films
	has_many :directors, through: :director_films
end
