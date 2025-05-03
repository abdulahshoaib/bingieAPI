class Movie < ApplicationRecord
  validates :imdb_id, uniqueness: true
end
