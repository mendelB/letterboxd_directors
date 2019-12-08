require 'pry'
class HomeController < ApplicationController
  def home
  end

  def fetch_directors
    user = User.find_or_create_by({username: params[:username]})

    cache_id = SecureRandom.random_number(1_000_000)
    Rails.cache.write(cache_id, user)
    session[:cache_id] = cache_id
  	LetterboxdScraper.scrape_films(user)

  	redirect_to action: 'directors', username: user.username
  end

  def directors
    if @user = User.find_by({username: params[:username]})
      directors = @user.directors.uniq
      if directors
        @directors = directors.map do |director| 
          { director: director, films: director.user_films(@user) } 
        end.sort_by { |director_obj| director_obj[:films].length }.reverse
        return
      end
    end
    flash[:notice] = "Please upload a CSV for data"
    redirect_to :root 
  end

  def director_films
    if user = User.find_by({username: params[:username]})
      @director = user.directors.find(params[:director].to_i)

      if !@director
        flash[:notice] = "No data for Director with the ID of #{params[:director]}!"
        return redirect_to :root 
      end

      @films = @director.films.where(id: user.films)
      
      render :director_films
    else
      flash[:notice] = "Please upload a CSV for data"
      return redirect_to :root 
    end
  end
end
