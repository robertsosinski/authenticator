# Generates hexidecimal based strings.
module KeyGenerator
  # Creates a key of the specified length, in which the default is 64 characters.
  #
  #  KeyGenerator.create => "531e00dac3da5ecf13e8489348e147e430e65bb4536cf4a693fcdded805d7d4d"
  #  KeyGenerator.create(32) => "50ef4925997677ad00994b2e8511a2e5"
  def self.create(length = 64)
    key = String.new
    
    length.times do 
      key << rand(16).to_s(16)
    end
    
    return key
  end
end
