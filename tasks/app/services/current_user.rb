# check Homework week2

# validates jwt token in auth service and returns current user
require 'net/http'

class CurrentUser
  include Interactor
  delegate :token, to: :context

  def call
    context.fail!(errors: 'Invalid token') unless token.present?
    uri = URI("http://auth:3001/jwt/validate")
    req = Net::HTTP::Post.new(uri)
    req.body = { token: token }.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end

    context.fail!(errors: 'Invalid token') unless res.code == '200'

    user_id = JSON.parse(res.body)['user_id']
    user = User.find_by(external_id: user_id)
    context.fail!(errors: 'User not found') unless user.present?

    context.user = user
  end
end
