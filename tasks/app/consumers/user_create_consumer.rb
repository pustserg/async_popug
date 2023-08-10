class UserCreateConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      Rails.logger.info "UserCreateConsumer: #{message}"
      message_body = JSON.parse(message.value)
      params = message_body.merge(external_id: message_body['id']).except('id')

      user = User.create(params.except)
      if user.persisted?
        Rails.logger.info "UserCreateConsumer: User #{user.external_id} created"
      else
        Rails.logger.info "UserCreateConsumer: User not created due to errors #{user.errors.full_messages}"
      end
    end
  end
end
