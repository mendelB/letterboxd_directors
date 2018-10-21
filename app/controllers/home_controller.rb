require 'pry'
class HomeController < ApplicationController
  def home
  end

  def fetch_directors
  	@directors = CSVHandler.handle(params["file"])

    cache_id = params["file"].tempfile.hash
    Rails.cache.write(cache_id, @directors)
    session[:cache_id] = cache_id

  	redirect_to :directors
  end

  def directors
    if cache_id = session[:cache_id]
      @directors = Rails.cache.fetch(cache_id) and return @directors
  	end
    flash[:notice] = "Please upload a CSV for data"
    redirect_to :root 
  end

  def director_films
    if session[:cache_id] and directors = Rails.cache.fetch(session[:cache_id])
      director_array = directors.find do |director|
        director[0].id === params[:director].to_i
      end

      if !director_array
        flash[:notice] = "No data for Director with the ID of #{params[:director]}!"
        return redirect_to :root 
      end

      @director = director_array[0]
      @films = director_array[1].sort_by { |film| film.year.to_i }
      
      render :director_films
    else
      flash[:notice] = "Please upload a CSV for data"
      return redirect_to :root 
    end
  end
end
