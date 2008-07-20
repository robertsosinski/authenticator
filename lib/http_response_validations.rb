# Additional HTTP Responses for RSpec
module HTTPResponseValidations
  HTTP_CREATED              = "201 Created"
  HTTP_ACCEPTED             = "202 Accepted"
  HTTP_UNAUTHORIZED         = "401 Unauthorized"
  HTTP_UNPROCESSABLE_ENTITY = "422 Unprocessable Entity"
  
  # Tests that a 201 Created response is received
  class BeCreated
    def initialize
      @http_code = HTTP_CREATED
    end
    
    # Matches the actual and expected response
    def matches?(response)
      @status  = response.headers["Status"]
      @status == @http_code
    end
    
    # Returns a failure message when called by a positive "should" match
    def failure_message
      "expected status to be '#{@http_code}' but received '#{@status}'"
    end
    
    # Returns a failure message when called by a negative "should_not" match
    def negative_failure_message
      "expected status to not be '#{@http_code}' but received '#{@status}'"
    end
  end
  
  # Tests that a 202 Accepted response is received
  class BeAccepted
    def initialize
      @http_code = HTTP_ACCEPTED
    end
    
    # Matches the actual and expected response
    def matches?(response)
      @status  = response.headers["Status"]
      @status == @http_code
    end
    
    # Returns a failure message when called by a positive "should" match
    def failure_message
      "expected status to be '#{@http_code}' but received '#{@status}'"
    end
    
    # Returns a failure message when called by a negative "should_not" match
    def negative_failure_message
      "expected status to not be '#{@http_code}' but received '#{@status}'"
    end
  end
  
  # Tests that a 401 UnAuthroized response is received
  class BeUnauthorized
    def initialize
      @http_code = HTTP_UNAUTHORIZED
    end
    
    # Matches the actual and expected response
    def matches?(response)
      @status  = response.headers["Status"]
      @status == @http_code
    end
    
    # Returns a failure message when called by a positive "should" match
    def failure_message
      "expected status to be '#{@http_code}' but received '#{@status}'"
    end
    
    # Returns a failure message when called by a negative "should_not" match
    def negative_failure_message
      "expected status to not be '#{@http_code}' but received '#{@status}'"
    end
  end
  
  # Tests that a 422 Unprocessable Entity response is received
  class BeUnprocessableEntity
    def initialize
      @http_code = HTTP_UNPROCESSABLE_ENTITY
    end
    
    # Matches the actual and expected response
    def matches?(response)
      @status  = response.headers["Status"]
      @status == @http_code
    end
    # Returns a failure message when called by a positive "should" match
    def failure_message
      "expected status to be '#{@http_code}' but received '#{@status}'"
    end
    
    # Returns a failure message when called by a negative "should_not" match
    def negative_failure_message
      "expected status to not be '#{@http_code}' but received '#{@status}'"
    end
  end
  
  # Calls the BeCreated class
  def be_created 
    BeCreated.new
  end
  
  # Calls the BeAccepted class
  def be_accepted
    BeAccepted.new
  end
  
  # Calls the BeUnauthroized class
  def be_unauthorized
    BeUnauthorized.new
  end
  
  # Calls the BeUnproccessableEntity class
  def be_unprocessable_entity
    BeUnprocessableEntity.new
  end
end