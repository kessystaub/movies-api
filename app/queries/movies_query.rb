class MoviesQuery
  def initialize
    @relation = Movie.all.order(:published_at)
  end

  def call
    @relation
  end

  def by_year(year)
    @relation = @relation.where(year:) unless year.nil?

    self
  end

  def by_genre(genre)
    @relation = @relation.where(genre:) unless genre.nil?

    self
  end

  def by_country(country)
    @relation = @relation.where(country:) unless country.nil?

    self
  end

  def by_title(title)
    @relation = @relation.where(title:) unless title.nil?

    self
  end

  def by_description(description)
    @relation = @relation.where(description:) unless description.nil?

    self
  end

  def by_published_at(published_at)
    @relation = @relation.where(published_at:) unless published_at.nil?

    self
  end
end
