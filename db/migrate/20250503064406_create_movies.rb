class CreateMovies < ActiveRecord::Migration[8.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :year
      t.string :imdb_id
      t.string :source
      t.datetime :fetched

      t.timestamps
    end
  end
end
