require 'ruby_gntp'
require 'nokogiri'
require 'open-uri'

def send_notif(title, text)
	GNTP.notify({
		:app_name => "Baboon",
		:title => title,
		:text => text
	})
end

def get_next_rer_A
	ratp_page = Nokogiri::HTML(open('http://www.ratp.fr/horaires/fr/ratp/rer/prochains_passages/RA/Nation/A'))
	
	horaires = "************************\n"
	ratp_page.css('fieldset.rer/table/tbody/tr').reverse[0...2].each do |l|
		tds = l.css("td").map { |td| td.text.strip }
		horaires << "#{tds[0]} -> #{tds[1]}: #{tds[2]}\n               -----\n"	
	end
	horaires
end

send_notif("Prochains RER (#{Time.now.strftime("%H:%M:%S")})", get_next_rer_A)
