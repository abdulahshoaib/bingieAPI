Rails.application.routes.draw do
  get "movies/search", to: "movies#search"
end
