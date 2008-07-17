class Mailer < ActionMailer::Base
  def activation(options)
    from "#{options[:site].support_title} <#{options[:site].email_address}>"
    recipients options[:account].email_address
    subject options[:site].activation_subject
    content_type 'text/html'
    
    body :site => options[:site], :account => options[:account]
  end
  
  def recovery(options)
    from "#{options[:site].support_title} <#{options[:site].email_address}>"
    recipients options[:account].email_address
    subject options[:site].recovery_subject
    content_type 'text/html'
    
    body :site => options[:site], :account => options[:account]
  end
end
