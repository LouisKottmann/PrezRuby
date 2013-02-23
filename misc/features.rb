# **********************
# * Exception handling *
def divide(numerator, denominator)
   puts numerator / denominator
rescue ZeroDivisionError
   puts 'you broke my method!'
end

divide 5, 0
#-> you broke my method!
divide 5, 2
#-> 2

# ********************
# * Boolean coercion *
def gimme(trinket)
   puts "take this #{trinket}" if trinket
end

gimme nil
#->
gimme 'nutcracker'
#-> take this nutcracker

# **************
# * Duck typed *
class Baboon
   def poke
      puts 'an angry baboon is now looking for you!'
   end
end

def poke(this)
   if this.respond_to? :poke
      this.poke
   else
      puts "can't poke this"
   end
end

poke Baboon.new
#-> an angry baboon is now looking for you!
poke nil
#-> can't poke this

# **********
# * Mixins *
module Ape
   def scratch
      puts 'aww yeaaah!'
   end
end

class Baboon
   include Ape
end

Baboon.new.scratch
#-> aww yeaaah!

