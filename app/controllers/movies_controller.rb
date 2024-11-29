require "csv"
class MoviesController < ApplicationController
  def index
    movies = Movie.all.order(:published_at)
    render json: movies
  end

  # GET /movies?year=2023&genre=Action&country=USA&title=Avengers

  def import_csv
    if params[:file].present?
      begin
        csv_file = params[:file]
        csv = CSV.read(csv_file.tempfile, headers: true)

        csv.each do |row|
          Movie.find_or_create_by!(
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
        render json: { error: "Erro ao importar: #{e.message}" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Nenhum arquivo enviado" }, status: :unprocessable_entity
    end
  end
end
