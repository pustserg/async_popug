class JwtDecode
  include Interactor

  delegate :token, to: :context

  def call
    payload = JWT.decode(token, 'jwt_secret', true, { algorithm: 'HS256' }).first
    context.user = User.find_by(id: payload['user_id'])
  rescue JWT::DecodeError
    context.fail!
  end
end
