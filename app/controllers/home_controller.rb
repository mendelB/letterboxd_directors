class HomeController < ApplicationController
  def home
  end

  def fetch_directors
  	@directors = CSVHandler.handle(params["file"])
  	session[:id] = SessionCsv.last.session_id
  	render :directors
  end

  def directors
  	if session[:id]
  		@directors = CSVHandler.handle(SessionCsv.find_by({session_id: session[:id]}).csv, false)
  		binding.pry
  	else
  		redirect_to :root
  	end
  end
end
