tds = ['lundi 21', 'Mission matin sdklfslkdjflksdjflkjsdklfjklsdjfklsdjfkljsdf', 'absence aprem']

day = tds.shift.split(' ')
morning, afternoon = tds
weekday   = day[0].ljust(8, ' ')
day_nr    = day[1].rjust(2, ' ')

def ellipsify_or_center(str, max_char)
  return str.center(max_char) if str.size <= max_char
  str[0..(max_char - 4)] + "..."
end

puts "************"
puts "Day: #{day} | Weekday: #{weekday} | Day_Nr: #{day_nr}"
puts "Morning: #{morning}"
puts "Afternoon: #{ellipsify_and_center(afternoon, 20)}"
puts "20 chars: #{ellipsify_and_center(morning, 20)}"
puts "Ellipsified: #{ellipsify_and_center("this text is 20 char", 20)}"