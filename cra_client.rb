require 'highline'
require 'open-uri'
require 'nokogiri'
require 'mechanize'
require 'term/ansicolor'
require 'pp'

hl = HighLine.new
login = hl.ask('username: ')
password = hl.ask('password: ') do |q|
  q.echo = '*'
end

def worked?(half_day)
  half_day.strip.start_with? 'Mission :'
end

def ellipsify_or_center(str, max_char = 20)
  return str.center(max_char) if str.size <= max_char
  str[0..(max_char - 4)] + "..."
end

mecha = Mechanize.new do |agent|
  # So@net uses SSL so we need to verify the certificate signature
  # we could bypass the checks but IT IS WRONG AND YOU WILL GO TO HELL
  # for that we need a file that defines certificate authorities (namely: cacert.pem)
  # - The cool way: https://gist.github.com/fnichol/867550 (setting the PATH didn't work for me, but it does download the *.pem file)
  # - Or download it from http://curl.haxx.se/ca/cacert.pem and put it somewhere convenient
  agent.ca_file = 'C:\RailsInstaller\cacert.pem'
  # So@net refreshes after login
  agent.follow_meta_refresh = true
end

signin_url = 'https://cas.soat.fr/cas/login?service=http://sonet.soat.fr/sonet/default.aspx'
mecha.get(signin_url) do |signin_page|
  cra_page = signin_page.form_with(id: 'fm1') do |signin_form|
    signin_form.username = login
    signin_form.password = password
  end.submit

  Nokogiri::HTML(cra_page.body).css('#ctl00_body_gdvCRA tr').drop(1).each do |tr|
    begin
      tds = tr.css('td').map { |td| td.text.strip }
      day = tds.shift.split(' ')
      morning, afternoon = tds
      weekday = day[0].rjust(8, ' ')
      day_nr  = day[1].rjust(2, ' ')

      puts "#{weekday} #{day_nr}: #{ellipsify_or_center(morning)} - #{ellipsify_or_center(afternoon)}"
    rescue
      puts $!.message
    end
  end
end

#ct100_body_gdvCRA