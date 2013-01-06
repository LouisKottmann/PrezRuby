# self: le chiffre lui même
# downto: boucle -- jusqu'à 1
# reduce: réduit un groupe d'objets en un seul en appliquant une méthode
# => 3 * 2 * 1 = 6

class Integer
   def factorial
      self.downto(1).reduce(:*)
   end
end

puts 3.factorial

# Au passage, Ruby se fiche pas mal des limites classiques sur les entiers. Remplacer 3 par 10000.