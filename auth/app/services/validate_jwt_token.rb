# check Homework week2

class ValidateJwtToken
  include Interactor
  delegate :token, to: :context

  def call
    result = JwtDecode.call(token: token)
    if result.success?
      context.user_id = result.user.id
    else
      context.fail!
    end
  end
end
