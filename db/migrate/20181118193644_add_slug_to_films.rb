class AddSlugToFilms < ActiveRecord::Migration[5.1]
  def change
    add_column :films, :slug, :string
  end
end
