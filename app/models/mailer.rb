# Handles sending any email messages.
class Mailer < ActionMailer::Base
  # Sends an Activation Letter to a newly created Account
  def activation(options)
    from "#{options[:site].support_title} <#{options[:site].email_address}>"
    recipients options[:account].email_address
    subject options[:site].activation_subject
    content_type 'text/html'
    
    body :site => options[:site], :account => options[:account]
  end
  
  # Sends a Recovery Letter to an Account where the owner has forgotten their password.
  def recovery(options)
    from "#{options[:site].support_title} <#{options[:site].email_address}>"
    recipients options[:account].email_address
    subject options[:site].recovery_subject
    content_type 'text/html'
    
    body :site => options[:site], :account => options[:account]
  end
end
