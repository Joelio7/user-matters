class AuthResponseSerializer
  def initialize(message:, token:, user:)
    @message = message
    @token = token
    @user = user
  end

  def as_json
    {
      message: @message,
      token: @token,
      user: UserSerializer.new(@user).as_json
    }
  end
end
