require "csv"
class MoviesController < ApplicationController
  def index
    movies = Movie.all
    render json: movies
  end

  def import_csv
    if params[:file].present?
      begin
        csv_file = params[:file].read
        csv = CSV.parse(csv_file, headers: true)

        csv.each do |row|
          Movie.create!(
            title: row["title"],
            genre: row["genre"],
            year: row["year"],
            country: row["country"],
            published_at: row["published_at"],
            description: row["description"]
          )
        end

        render json: { message: "Importação de arquivo CSV realizada com sucesso!" }, status: :ok
      rescue StandardError => e
        render json: { error: "Erro ao processar o arquivo: #{e.message}" }, status: :unprocessable_entity
      end
    end
  end
end
