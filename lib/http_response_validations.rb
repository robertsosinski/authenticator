# Adds additional HTTP respones to the RSpec Controller testing suite.  This way, for example, you can have:
#
#  response.should be_unsupported_media_type
#
# for a test, ensuring that an unsupported format returns a 415 Unsupported Media Type error.
module HTTPResponseValidations
  HTTP_CREATED                = "201 Created"
  HTTP_ACCEPTED               = "202 Accepted"
  HTTP_UNAUTHORIZED           = "401 Unauthorized"
  HTTP_UNSUPPORTED_MEDIA_TYPE = "415 Unsupported Media Type"
  HTTP_UNPROCESSABLE_ENTITY   = "422 Unprocessable Entity"
  
  class BeCreated
    def initialize
      @http_code = HTTP_CREATED
    end
    
    def matches?(response)
      @status  = response.headers["Status"]
      @status == @http_code
    end
    
    def failure_message
      "expected status to be '#{@http_code}' but received '#{@status}'"
    end
    
    def negative_failure_message
      "expected status to not be '#{@http_code}' but received '#{@status}'"
    end
  end
  
  class BeAccepted
    def initialize
      @http_code = HTTP_ACCEPTED
    end
    
    def matches?(response)
      @status  = response.headers["Status"]
      @status == @http_code
    end
    
    def failure_message
      "expected status to be '#{@http_code}' but received '#{@status}'"
    end
    
    def negative_failure_message
      "expected status to not be '#{@http_code}' but received '#{@status}'"
    end
  end
  
  class BeUnauthorized
    def initialize
      @http_code = HTTP_UNAUTHORIZED
    end
    
    def matches?(response)
      @status  = response.headers["Status"]
      @status == @http_code
    end
    
    def failure_message
      "expected status to be '#{@http_code}' but received '#{@status}'"
    end
    
    def negative_failure_message
      "expected status to not be '#{@http_code}' but received '#{@status}'"
    end
  end
  
  class BeUnsupportedMediaType
    def initialize
      @http_code = HTTP_UNSUPPORTED_MEDIA_TYPE
    end
    
    def matches?(response)
      @status  = response.headers["Status"]
      @status == @http_code
    end
    
    def failure_message
      "expected status to be '#{@http_code}' but received '#{@status}'"
    end
    
    def negative_failure_message
      "expected status to not be '#{@http_code}' but received '#{@status}'"
    end
  end
  
  class BeUnprocessableEntity
    def initialize
      @http_code = HTTP_UNPROCESSABLE_ENTITY
    end
    
    def matches?(response)
      @status  = response.headers["Status"]
      @status == @http_code
    end
    
    def failure_message
      "expected status to be '#{@http_code}' but received '#{@status}'"
    end
    
    def negative_failure_message
      "expected status to not be '#{@http_code}' but received '#{@status}'"
    end
  end
  
  def be_created 
    BeCreated.new
  end
  
  def be_accepted
    BeAccepted.new
  end
  
  def be_unauthorized
    BeUnauthorized.new
  end
  
  def be_unsupported_media_type
    BeUnsupportedMediaType.new
  end
  
  def be_unprocessable_entity
    BeUnprocessableEntity.new
  end
end