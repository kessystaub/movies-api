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
        allow(Movie).to receive(:find_or_create_by!).and_raise(StandardError, 'Erro simulado')
      end

      it 'returns an error message' do
        post :import_csv, params: { file: file }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Erro ao importar: Erro simulado')
      end
    end
  end
end
