class UserFilm < ApplicationRecord
	belongs_to :film
	belongs_to :user
end
