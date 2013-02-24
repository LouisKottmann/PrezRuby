require 'highline'
require 'open-uri'
require 'nokogiri'
require 'mechanize'
require 'term/ansicolor'

# For coloring with term-ansicolor under windows, you will need this: https://github.com/adoxa/ansicon
# You can download source+binaries here: http://adoxa.3eeweb.com/ansicon/dl.php?f=ansicon
# You must then open a command line to the x86 or x64 folder and run 'ansicon.exe -i' to install it
class String
  include Term::ANSIColor
end

def worked?(half_day)
  half_day.strip.start_with? 'Mission :'
end

def ellipsify_or_center(str, max_char = 20)
  if str.size <= max_char
    str.center(max_char)
  else
    str[0..(max_char - 4)] + '...'
  end
end

alias :ec :ellipsify_or_center

def colorize(half_day)
  if worked? half_day
    half_day.on_green
  else
    half_day.on_red
  end
end

alias :c :colorize

hl = HighLine.new

login = hl.ask('username: ')
password = hl.ask('password: ') do |q|
  q.echo = '*'
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

  doc = Nokogiri::HTML(cra_page.body)

  puts doc.css('#ctl00_body_ddlDate')
       .search('option[@selected="selected"]')
       .text.center(56).blue.on_white.bold

  doc.css('#ctl00_body_gdvCRA tr').drop(1).each do |tr|
    tds = tr.css('td').map { |td| td.text.strip }
    day = tds.shift.split(' ')
    morning, afternoon = tds
    weekday = day[0].rjust(8, ' ')
    day_nr = day[1].rjust(2, ' ')

    puts "#{weekday} #{day_nr}: #{colorize(ellipsify_or_center(morning))} - #{c(ec(afternoon))}"
  end
end