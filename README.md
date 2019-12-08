# Letterboxd Directors

I love Letterboxd. I love the [(pro)](https://letterboxd.com/pro/) [stats](https://letterboxd.com/Mendel/stats/) feature, seeing the list of directors who's work I've seen and the amount of their films that I've logged. The stats page is unfortunately limited to the top 20 directors with the most logged films. 

This Rails app will scrape the Letterboxd site per provided username, compile a list of your logged films, and using the [TMDB API](https://developers.themoviedb.org/3/getting-started), compile the full list of your logged films per director. 

Would love to integrate this with the [Letterboxd API](https://letterboxd.com/api-beta/) if that's released to the public someday 🙏 (I applied for beta access but haven't heard back 😢).

## Usage
```bash
$ bundle install
$ rails s
```

- 🖥 Visit `http://localhost:3000`.
- ⌨️  Enter Letterboxd username & submit form.
- 📊 The scraping takes some time, see progress log in the command line.
- 🎁 You'll eventually be redirected to your full stat list of directors.
