module KeyGenerator
  def self.create(length = 64)
    key = String.new
    
    length.times do 
      key << rand(16).to_s(16)
    end
    
    return key
  end
end
