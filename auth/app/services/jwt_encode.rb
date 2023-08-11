class JwtEncode
  include Interactor
  delegate :user, to: :context

  def call
    context.token = JWT.encode payload, 'jwt_secret', 'HS256'
  end

  private

  def payload
    {
      user_id: user.id,
      exp: 1.year.from_now.to_i
    }
  end
end
