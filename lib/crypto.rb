require 'openssl'
require 'digest/sha2'

module Crypto
  KEY = "36f1344af5ae8ecab14a84c2003287d4c0784e172cc6ef1aa8cd0c1fb7c10147"
    
  def self.encrypt(plain_text)    
    crypto = start(:encrypt)

    cipher_text = crypto.update(plain_text)
    cipher_text << crypto.final

    cipher_hex = cipher_text.unpack("H*").join

    return cipher_hex
  end
  
  def self.decrypt(cipher_hex)
    crypto = start(:decrypt)
    
    cipher_text = cipher_hex.gsub(/(..)/){|h| h.hex.chr}
    
    plain_text = crypto.update(cipher_text)
    plain_text << crypto.final

    return plain_text
  end
  
  private
  
  def self.start(mode)
    crypto = OpenSSL::Cipher::Cipher.new('aes-256-ecb').send(mode)
    crypto.key = KEY
    return crypto
  end
end
