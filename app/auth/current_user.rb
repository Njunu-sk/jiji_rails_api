class CurrentUser
  def initialize(auth_token)
    @auth_token = auth_token
  end

  def call
    {
      user: user
    }
  end

  private

  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
  rescue ::ActiveRecord::RecordNotFound => e
    raise(
      ::ExceptionHandler::InvalidToken,
      ("#{::Message.invalid_token} #{e.message}")
    )
  end

  def decoded_auth_token
    @decoded_auth_token ||= ::JsonWebToken.decode(@auth_token)
  end
end
