class CreateDirectorFilms < ActiveRecord::Migration[5.1]
  def change
    create_table :director_films do |t|
      t.integer :director_id
      t.integer :film_id

      t.timestamps
    end
  end
end
