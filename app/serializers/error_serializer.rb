class ErrorSerializer
  def initialize(message:, errors: nil)
    @message = message
    @errors = errors
  end

  def as_json
    result = { message: @message }
    result[:errors] = @errors if @errors
    result
  end
end
