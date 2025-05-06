# Bingie API

A movie search engine that uses OMDB API to get the movie data, it caches the movie information to the local database when fetched and if required by the user is loaded from the database.

# Considerations:

 1. The OMDB API takes in atleast 3 words for searching.
 2. The Cache is searched through based of any matching letters of the request made.

# Working:

The backend API gets results from the API, stores it in the database if the IMDB ID is unique and not already in the cache (rejected) otherwise. The backend then creates a JSON response that comprises of all the local cache results and the OMDB API result, such that only a fresh fetch would be sent as a API result.
The frontend then parses the data into a type that is similar to the json data. The data is destructured into an object of this type. Which then is shown on the screen.

# Additionals:

  - Added debounce
  - Added loading animation on searching
