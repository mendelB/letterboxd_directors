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
      @directors = Rails.cache.fetch(cache_id)
  	else
      flash[:notice] = "Please upload a CSV for data"
      redirect_to :root 
  	end
  end

  def director_films
    if session[:cache_id]
      directors = Rails.cache.fetch(session[:cache_id])
      director_array = directors.find do |director|
        director[0].name === params[:director].gsub('+', ' ')
      end
      @director = director_array[0]
      @films = director_array[1].sort_by { |film| film.year.to_i }
      if @director
        render :director_films
      else
        flash[:notice] = "No data for #{params[:director]}!"
        redirect_to :root 
      end
    else
      flash[:notice] = "Please upload a CSV for data"
    end
  end
end
