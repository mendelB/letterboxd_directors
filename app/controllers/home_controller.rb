require 'pry'
class HomeController < ApplicationController
  def home
  end

  def fetch_directors
    user = User.find_or_create_by({username: params[:username]})
  	LetterboxdScraper.scrape_films(user)

  	redirect_to action: 'directors', username: user.username
  end

  def directors
    if @user = User.find_by({username: params[:username]})
      directors = @user.directors.uniq
      if directors
        # @TODO: Clean this up into a model method.
        @directors = directors.map do |director| 
          { director: director, films: director.user_films(@user) } 
        end.sort_by { |director_obj| director_obj[:films].length }.reverse
        return
      end
    end
    flash[:notice] = "No data found for this user. Please enter your Letterboxd username."
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
      flash[:notice] = "No data found for this user. Please enter your Letterboxd username."
      return redirect_to :root 
    end
  end
end
