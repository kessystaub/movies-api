require 'rails_helper'

RSpec.describe MoviesQuery do
  let(:movie) { create(:movie) }
  subject { described_class.new }

  describe '#call' do
    fit 'returns a list of movies' do
      movie = create(:movie)

      expect(subject.call).to eq [ movie ]
    end

    it 'returns the movies list sorted by #published_at' do
      movie_a = create(:movie)
      movie_b = create(:movie)
      movie_c = create(:movie)

      expect(subject.call).to eq [ movie_a, movie_b, movie_c ]
    end
  end

  describe '#by_year' do
    it 'prepares #call to return only records from the year passed if its value is true' do
      movie = create(:movie, year: '1999')
      incorrent_movie = create(:movie, year: '2000')

      result = subject.by_year('1999').call

      expect(result).to include(movie)
      expect(result).not_to include(incorrent_movie)
    end

    it 'is not applied if the param is nil' do
      movie = create(:movie, year: '1999')
      incorrent_movie = create(:movie, year: '2000')

      result = subject.by_year('1999').call

      expect(result).to include(movie, incorrent_movie)
    end

    it 'returns self' do
      query = described_class.new
      expect(query.by_year(nil)).to eq query
    end
  end
end
