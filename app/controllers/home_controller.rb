class HomeController < ApplicationController
  def home
  end

  def fetch_directors
  	@directors = CSVHandler.handle(params["file"])
  	render :directors
  end

  def directors
  end
end
