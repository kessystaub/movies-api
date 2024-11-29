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
end
