class JsonWebToken
  # secret to encode and decode token
  HMAC_SECRET = "#{ENV["SECRET_KEY_BASE"]}"

  def self.encode(payload, exp = 2.hours.from_now)
    payload[:exp] = exp.to_i
    ::JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    body = ::JWT.decode(token, HMAC_SECRET)[0]
    ::HashWithIndifferentAccess.new body
  rescue ::JWT::DecodeError => e
    raise ::ExceptionHandler::InvalidToken, e.message
  end
end
