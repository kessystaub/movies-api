require 'rails_helper'

RSpec.describe MoviesQuery do
  subject { described_class.new }

  describe '#call' do
    it 'returns a list of movies' do
      movie = Movie.create!

      expect(subject.call).to eq [ movie ]
    end

    it 'returns the movies list sorted by #published_at' do
      movie_a = Movie.create!(title: 'Movie A', published_at: Date.new(2022, 1, 1))
      movie_b = Movie.create!(title: 'Movie B', published_at: Date.new(2020, 1, 1))
      movie_c = Movie.create!(title: 'Movie C', published_at: Date.new(2021, 1, 1))

      sorted_movies = [ movie_b, movie_c, movie_a ]

      expect(subject.call).to eq(sorted_movies)
    end
  end

  describe '#by_year' do
    it 'prepares #call to return only records from the param passed' do
      movie = Movie.create!(year: '1999')
      incorrect_movie = Movie.create!(year: '2000')

      result = subject.by_year('1999').call

      expect(result).to include(movie)
      expect(result).not_to include(incorrect_movie)
    end

    it 'is not applied if the param is nil' do
      movie = Movie.create!(year: '1999')
      incorrect_movie = Movie.create!(year: '2000')

      result = subject.by_year(nil).call

      expect(result).to include(movie, incorrect_movie)
    end

    it 'returns self' do
      query = described_class.new
      expect(query.by_year(nil)).to eq query
    end
  end

  describe '#by_genre' do
    it 'prepares #call to return only records from the param passed' do
      action_movie = Movie.create!(genre: 'Action')
      comedy_movie = Movie.create!(genre: 'Comedy')

      result = subject.by_genre('Action').call

      expect(result).to include(action_movie)
      expect(result).not_to include(comedy_movie)
    end

    it 'is not applied if the param is nil' do
      action_movie = Movie.create!(genre: 'Action')
      comedy_movie = Movie.create!(genre: 'Comedy')

      result = subject.by_genre(nil).call

      expect(result).to include(action_movie, comedy_movie)
    end

    it 'returns self' do
      query = described_class.new
      expect(query.by_genre(nil)).to eq query
    end
  end

  describe '#by_country' do
    it 'prepares #call to return only records from the param passed' do
      brazil_movie = Movie.create!(country: 'Brazil')
      mexico_movie = Movie.create!(country: 'Mexico')

      result = subject.by_country('Mexico').call

      expect(result).to include(mexico_movie)
      expect(result).not_to include(brazil_movie)
    end

    it 'is not applied if the param is nil' do
      brazil_movie = Movie.create!(country: 'Brazil')
      mexico_movie = Movie.create!(country: 'Mexico')

      result = subject.by_country(nil).call

      expect(result).to include(brazil_movie, mexico_movie)
    end

    it 'returns self' do
      query = described_class.new
      expect(query.by_country(nil)).to eq query
    end
  end

  describe '#by_title' do
    it 'prepares #call to return only records from the param passed' do
      movie_with_title = Movie.create!(title: 'Title')
      movie_with_another_title = Movie.create!(title: 'Another Title')

      result = subject.by_title('Title').call

      expect(result).to include(movie_with_title)
      expect(result).not_to include(movie_with_another_title)
    end

    it 'is not applied if the param is nil' do
      movie_with_title = Movie.create!(title: 'Title')
      movie_with_another_title = Movie.create!(title: 'Another Title')

      result = subject.by_title(nil).call

      expect(result).to include(movie_with_title, movie_with_another_title)
    end

    it 'returns self' do
      query = described_class.new
      expect(query.by_title(nil)).to eq query
    end
  end

  describe '#by_description' do
    it 'prepares #call to return only records from the param passed' do
      movie_with_description = Movie.create!(description: 'Description')
      movie_with_another_description = Movie.create!(description: 'Another Description')

      result = subject.by_description('Description').call

      expect(result).to include(movie_with_description)
      expect(result).not_to include(movie_with_another_description)
    end

    it 'is not applied if the param is nil' do
      movie_with_description = Movie.create!(description: 'Description')
      movie_with_another_description = Movie.create!(description: 'Another Description')

      result = subject.by_description(nil).call

      expect(result).to include(movie_with_description, movie_with_another_description)
    end

    it 'returns self' do
      query = described_class.new
      expect(query.by_description(nil)).to eq query
    end
  end

  describe '#by_published_at' do
    it 'prepares #call to return only records from the param passed' do
      date = Date.new(2022, 1, 1)
      movie_with_date = Movie.create!(published_at: date)
      movie_with_another_date = Movie.create!(published_at: Date.new(2023, 1, 1))

      result = subject.by_published_at(date).call

      expect(result).to include(movie_with_date)
      expect(result).not_to include(movie_with_another_date)
    end

    it 'is not applied if the param is nil' do
      date = Date.new(2022, 1, 1)
      movie_with_date = Movie.create!(published_at: date)
      movie_with_another_date = Movie.create!(published_at: Date.new(2023, 1, 1))

      result = subject.by_published_at(nil).call

      expect(result).to include(movie_with_date, movie_with_another_date)
    end

    it 'returns self' do
      query = described_class.new
      expect(query.by_published_at(nil)).to eq query
    end
  end
end
