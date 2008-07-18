module ApplicationHelper
  def time_format(time)
    strftime("%B %d, %Y at %l:%M %p")
  end
  
  def letter_options
    $letter_options_list = ['#'].concat(('a'..'z').to_a)
  end
end
