This script fetches movies available on hbo, queries for them on rotten tomatoes, and sorts them by their tomato rating.
It's slow as hell because it sends a separate request for each movie, because I
didn't bother to get access to rotten tomato's real API.
Oh well.

Just clone this guy, cd into the folder and run
```
ruby movie_rating_script.rb
```