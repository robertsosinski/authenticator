class Mailer < ActionMailer::Base
  def activation(options)
    from "#{options[:site].support_title} <#{options[:site].email_address}>"
    recipients options[:account].email_address
    subject "Account Activation"
    content_type 'text/html'
    
    body :verification_key => options[:account].verification_key
  end
  
  def recovery(options)
    from "Recovery <development@capansis.com>"
    recipients options[:email]
    subject "Account Recovery"
    content_type 'text/html'
    
    body :verification_key => options[:verification_key]
  end
end
