class Mailer < ActionMailer::Base
  def activation(options)
    from "Simple and Restful <development@capansis.com>"
    recipients options[:email]
    subject "Simple and Restful Account Recovery"
    content_type 'text/html'
    
    body :verification_key => options[:verification_key]
  end
  
  def recovery(options)
    from "Simple and Restful <development@capansis.com>"
    recipients options[:email]
    subject "Simple and Restful Account Recovery"
    content_type 'text/html'
    
    body :verification_key => options[:verification_key]
  end
end
