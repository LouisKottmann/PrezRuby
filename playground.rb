require 'nokogiri'
require 'pp'

doc = Nokogiri::HTML <<ENDXML
   <h1 class="title">
      <select name="ctl00_body_ddlDate" id="ctl00_body_ddlDate" class="liste">
   	   <option value="01/12/2012 00:00:00">d&#233;cembre 2012</option>
   	   <option value="01/01/2013 00:00:00">janvier 2013</option>
   	   <option selected="selected" value="01/02/2013 00:00:00">f&#233;vrier 2013</option>
      </select>
   </h1>
ENDXML

pp doc.css('#ctl00_body_ddlDate')
      .search('option[@selected="selected"]')
      .text