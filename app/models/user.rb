class User < ApplicationRecord
	has_many :user_films
	has_many :films, through: :user_films
	has_many :director_films, through: :films
	has_many :directors, through: :director_films
end
