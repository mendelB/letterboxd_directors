class HomeController < ApplicationController
  def home
  end

  def fetch_directors
  	@directors = CSVHandler.handle(params["file"])
    session_data = SessionCache.create({session_id: params["file"].tempfile, data: @directors})
  	session[:data_id] = session_data.session_id
    binding.pry
  	render :directors
  end

  def directors
  	if session[:data_id]
  		@directors = SessionCache.find_by({session_id: session[:data_id]}).data
  	else
      flash[:notice] = "Please upload a CSV for data"
      redirect_to :root 
  	end
  end
end
