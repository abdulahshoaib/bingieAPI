Rails.application.routes.draw do
  get "movies", to: "movies#index"
  get "movies/search", to: "movies#search"
end
