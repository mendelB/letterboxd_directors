require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open('https://letterboxd.com/mendel/films/'))

final_page = doc.css('.pagination ul li')[-1].css('a')[0].attributes['href'].value

final_page_num = final_page.match(/\d+/).to_s[-1].to_i

final_page_num.times do |i|
	page = Nokogiri::HTML(open('https://letterboxd.com/mendel/films/page/' + i.to_s))
	page.css('.poster-list li div').each do |poster|
		slug = poster.attributes['data-film-slug'].value
		film = Nokogiri::HTML(open('https://letterboxd.com' + slug))

		header = film.css('#featured-film-header')[0]
		title = header.css('h1').text
		year = header.css('.number').text

		p [title, year]
	end
end






