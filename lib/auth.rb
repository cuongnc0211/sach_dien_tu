require 'jwt'

class Auth
  ALGORITHM = Rails.application.credentials.dig(:secret, :auth, :algorithm)
  AUTH_SECRET = Rails.application.credentials.dig(:secret, :auth, :salt)

  def self.issue(payload)
    JWT.encode(
      payload,
      AUTH_SECRET,
      ALGORITHM)
  end

  def self.decode(token)
    JWT.decode(token,
      AUTH_SECRET,
      true,
      { algorithm: ALGORITHM }).first
  end
end
