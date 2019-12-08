# Letterboxd Directors

I love Letterboxd. I love the [(pro)](https://letterboxd.com/pro/) [stats](https://letterboxd.com/Mendel/stats/) feature, seeing the list of directors who's work I've seen and the amount of their films that I've logged. The stats page is unfortunately limited to the top 20 directors with the most logged films. 

This Rails app will scrape the Letterboxd site per provided username, compile a list of your logged films, and using the [TMDB API](https://developers.themoviedb.org/3/getting-started), compile the full list of your logged films per director. 

The app is pretty dang slow on the initial parsing of your movie logs, because we need to visit every single film page individually (if the app hasn't yet stored the film locally) in order to parse the film info & directors (I tried using the TMDB API for this but it was a bit flaky since we're relying on the slug from the user's film index which sometimes yields wrong data from TMDB). Would love to integrate this with the [Letterboxd API](https://letterboxd.com/api-beta/) if that's released to the public someday 🙏 (I applied for beta access but haven't heard back 😢).

## Usage

Create a `.env` file and set a `TMDB_API_KEY` variable to your TMDB API _v3 auth_ key.

```bash
$ bundle install
$ rails db:migrate
$ rails s
```

- 🖥 Visit `http://localhost:3000`.
- ⌨️  Enter Letterboxd username & submit form.
- 📊 The scraping takes some time, see progress log in the command line.
- 🎁 You'll eventually be redirected to your full stat list of directors.
