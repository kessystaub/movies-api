require "csv"
class MoviesController < ApplicationController
  def index
    movies_query = MoviesQuery.new
    movies = movies_query.by_year(params[:year])
                         .by_genre(params[:genre])
                         .by_country(params[:country])
                         .by_title(params[:title])
                         .by_description(params[:description])
                         .by_published_at(params[:published_at])
                         .call

    render json: movies.as_json(only: [ :id, :title, :genre, :year, :country, :published_at, :description ])
  end

  def import_csv
    if params[:file].present?
      begin
        csv_file = params[:file]
        csv = CSV.read(csv_file.tempfile, headers: true)

        csv.each do |row|
          Movie.find_or_create_by!(
            title: row["title"],
            genre: row["listed_in"],
            year: row["release_year"],
            country: row["country"],
            published_at: row["date_added"] ? Date.parse(row["date_added"]) : nil,
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
