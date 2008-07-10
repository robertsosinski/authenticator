class Mailer < ActionMailer::Base
  def recovery(options)
    from "Simple and Restful <development@capansis.com>"
    recipients options[:email]
    subject "Simple and Restful Account Recovery"
    content_type 'text/html'
    
    body :verification_key => options[:verification_key], :domain => options[:domain]
  end
end
