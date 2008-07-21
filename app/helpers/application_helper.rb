module ApplicationHelper
  # Supplies the letters needed for letter based pagination.
  def letter_options
    $letter_options_list = ['#'].concat(('a'..'z').to_a)
  end
  
  # Prototype generator that hides the flash message.
  def hide_flash
    update_page do |page|
      page[:flash].hide
    end
  end
end
