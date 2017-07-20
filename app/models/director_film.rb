class DirectorFilm < ApplicationRecord
	belongs_to :film
	belongs_to :director
end
