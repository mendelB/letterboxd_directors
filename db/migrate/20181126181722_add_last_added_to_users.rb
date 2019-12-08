class AddLastAddedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_added, :string
  end
end
