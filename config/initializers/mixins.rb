class String
  def is_a_key?
    self.length.equal?(64) ? true : false
  end
end