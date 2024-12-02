require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe 'GET #index' do
    let!(:movie1) { Movie.create!(title: 'Title1', genre: 'Action', year: 2020, country: 'USA', published_at: '2020-01-01', description: 'Desc1') }
    let!(:movie2) { Movie.create!(title: 'Title2', genre: 'Comedy', year: 2021, country: 'Canada', published_at: '2021-06-01', description: 'Desc2') }

    it 'returns filtered movies based on params' do
      get :index, params: { genre: 'Action' }

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(1)
      expect(json_response.first['title']).to eq('Title1')
    end

    it 'returns all movies if no filters are applied' do
      get :index

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(2)
    end
  end

  describe 'POST #import_csv' do
    let(:file_path) { Rails.root.join('spec/fixtures/files/movies.csv') }
    let(:file) { fixture_file_upload(file_path, 'text/csv') }

    context 'when a valid file is provided' do
      it 'imports movies from the CSV file' do
        expect do
          post :import_csv, params: { file: file }
        end.to change(Movie, :count).by(2)

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Importação de arquivo CSV realizada com sucesso!')
      end
      
      it 'creates the movies according to the file informations' do
        expect do
          post :import_csv, params: { file: file }
        end.to change(Movie, :count).by(1)
      
        movie1 = Movie.find_by(show_id: 's64')
        movie2 = Movie.find_by(show_id: 's66')
      
        expect(movie1.title).to eql('Movie 1')
        expect(movie1.genre).to eql('Crime TV Shows, TV Dramas, TV Mysteries')
        expect(movie1.year).to eql('2020')
        expect(movie1.country).to eql('United States')
        expect(movie1.published_at).to eql(Date.parse('June 5, 2020'))
        expect(movie1.description).to eql('Description 1.')
        expect(movie1.show_id).to eql('s64')
        expect(movie1.movie_type).to eql('TV Show')
        expect(movie1.director).to be_nil
        expect(movie1.cast).to eql('Cast 1')
        expect(movie1.rating).to eql('TV-MA')
        expect(movie1.duration).to eql('4 Seasons')
      
        expect(movie2.title).to eql('Movie 2')
        expect(movie2.genre).to eql('Horror Movies, Thrillers')
        expect(movie2.year).to eql('2014')
        expect(movie2.country).to eql('Brazil')
        expect(movie2.published_at).to eql(Date.parse('January 13, 2019'))
        expect(movie2.description).to eql('Description 2.')
        expect(movie2.show_id).to eql('s66')
        expect(movie2.movie_type).to eql('Movie')
        expect(movie2.director).to eql('Daniel Stamm')
        expect(movie2.cast).to eql('Cast 2')
        expect(movie2.rating).to eql('R')
        expect(movie2.duration).to eql('93 min')
      end

      it 'does not create repeated movies' do
        Movie.create!(
          title: 'Movie 2',
          genre: 'Horror Movies, Thrillers',
          year: 2014,
          country: 'Brazil',
          published_at: Date.parse('January 13, 2019'),
          description: 'Description 2.',
          show_id: 's66',
          movie_type: 'Movie',
          director: 'Daniel Stamm',
          cast: 'Cast 2',
          rating: 'R',
          duration: '93 min'
        )

        expect do
          post :import_csv, params: { file: file }
        end.to change(Movie, :count).by(1)
      end
    end

    context 'when no file is provided' do
      it 'returns an error' do
        post :import_csv

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Nenhum arquivo enviado')
      end
    end

    context 'when there is an error during import' do
      before do
        allow(Movie).to receive(:find_or_create_by!).and_raise(StandardError, 'Erro')
      end

      it 'returns an error message' do
        post :import_csv, params: { file: file }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Erro ao importar: Erro')
      end
    end
  end
end
