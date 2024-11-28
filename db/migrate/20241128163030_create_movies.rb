class CreateMovies < ActiveRecord::Migration[7.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :genre
      t.string :year
      t.string :country
      t.date :published_at
      t.text :description

      t.timestamps
    end
  end
end
