# Sends Account activation and recovery messages via email.
class Mailer < ActionMailer::Base
  # Sends an Invitation Letter to a newly created Account along with the temporary password.
  def invitation(options)
    from "#{options[:site].support_title} <#{options[:site].email_address}>"
    recipients options[:account].email_address
    subject options[:site].invitation_subject
    content_type 'text/html'
    
    body :site => options[:site], :account => options[:account], :temporary_password => options[:temporary_password]
  end
  
  # Sends an Activation Letter to a newly created Account.
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
