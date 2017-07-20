class CreateSessionCaches < ActiveRecord::Migration[5.1]
  def change
    create_table :session_caches do |t|
      t.string :data
      t.string :session_id

      t.timestamps
    end
  end
end
