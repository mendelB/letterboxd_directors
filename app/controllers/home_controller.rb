class HomeController < ApplicationController
  def home
  end

  def fetch_directors
  	@directors = CSVHandler.handle(params["file"])
    session_data = SessionCache.create({session_id: params["file"].tempfile, data: @directors})
  	session[:data_id] = session_data.session_id
  	redirect_to :directors
  end

  def directors
  	if session[:data_id]
  		@directors = SessionCache.find_by({session_id: session[:data_id]}).data
  	else
      flash[:notice] = "Please upload a CSV for data"
      redirect_to :root 
  	end
  end

  def director_films
    if session[:data_id]
      @directors = SessionCache.find_by({session_id: session[:data_id]}).data
      @director = @directors.find do |director|
        director[0].name === params[:director].gsub('+', ' ')
      end
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
