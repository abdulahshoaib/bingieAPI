require "json"
require "net/http"

class MoviesController < ApplicationController
  OMDB_API_KEY = ENV["OMDB_API_KEY"]
  OMDB_BASE_URL = "http://www.omdbapi.com/"

  def index
     @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
    render json: @movie
  end

  def search
    query  = params[:q]
    is_partial_word = query.length < 3 || !query.match?(/^\w+$/)

    @local_results = Movie.where("title LIKE ?", "%#{query}%").to_a
    @omdb_results = []
    existing_imdbID = @local_results.pluck(:imdb_id)

    if is_partial_word || @local_results.size < 5
       uri = URI(OMDB_BASE_URL)
       uri.query = URI.encode_www_form({
        apikey: OMDB_API_KEY,
        s: query
      })

      response = Net::HTTP.get_response(uri)

      if response.is_a?(Net::HTTPSuccess)
        omdb_data = JSON.parse(response.body)

        if omdb_data["Response"] == "True"
          raw_results = omdb_data["Search"]
          new_results = raw_results.reject { |movie| existing_imdbID.include?(movie["imdbID"]) }

          new_results.each do |movie|
            Movie.create!(
              title: movie["Title"],
              year: movie["Year"],
              imdb_id: movie["imdbID"],
              source: "API",
              fetched: Time.now
            )
          end
          @omdb_results = new_results
        else
          @omdb_results = []
        end
      else
        @omdb_results = [ "Error: #{response.code} - #{response.body}" ]
      end
    else

    end
    render :search
  end
end
