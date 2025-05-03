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

    @local_results = Movie.where("title LIKE ?", "%#{query}%")

    if @local_results.empty? || @local_results.size <=5
       uri = URI(OMDB_BASE_URL)
       uri.query = URI.encode_www_form({
        apikey: OMDB_API_KEY,
        s: query
      })

      response = Net::HTTP.get_response(uri)

      if response.is_a?(Net::HTTPSuccess)
        omdb_data = JSON.parse(response.body)

        if omdb_data["Response"] == "True"
          @omdb_results = omdb_data["Search"]
        else
          @omdb_results = [ "No Res" ]
        end
      else
        @omdb_results = [ "Error: #{response.code} - #{response.body}" ]
      end
    else
      @omdb_results = [ "No Local Res" ]
    end
  end
end
