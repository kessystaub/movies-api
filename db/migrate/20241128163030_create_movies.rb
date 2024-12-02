class CreateMovies < ActiveRecord::Migration[7.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :genre
      t.string :year
      t.string :country
      t.date :published_at
      t.text :description
      t.string :show_id
      t.string :movie_type
      t.string :director
      t.string :cast
      t.string :rating
      t.string :duration

      t.timestamps
    end
  end
end
