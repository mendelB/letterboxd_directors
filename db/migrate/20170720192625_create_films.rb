class CreateFilms < ActiveRecord::Migration[5.1]
  def change
    create_table :films do |t|
      t.string :title
      t.string :year
      t.string :tmdb_id
      t.string :poster_img_url

      t.timestamps
    end
  end
end
