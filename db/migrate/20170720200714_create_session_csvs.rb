class CreateSessionCsvs < ActiveRecord::Migration[5.1]
  def change
    create_table :session_csvs do |t|
      t.string :session_id
      t.string :csv

      t.timestamps
    end
  end
end
