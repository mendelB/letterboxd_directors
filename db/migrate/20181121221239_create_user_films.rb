class CreateUserFilms < ActiveRecord::Migration[5.1]
  def change
    create_table :user_films do |t|
      t.integer :user_id
      t.integer :film_id
    end
  end
end
