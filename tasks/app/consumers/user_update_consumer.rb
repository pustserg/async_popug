class UserUpdateConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      Rails.logger.info "UserUpdateConsumer: #{message}"
      message_body = JSON.parse(message.value)
      params = message_body['data'].merge(external_id: message_body['id']).except('id')

      user = User.find_by(external_id: params[:external_id])

      if user && user.update(params)
        Rails.logger.info "UserUpdateConsumer: User #{user.id} updated"
      elsif user.nil?
        Rails.logger.info "UserUpdateConsumer: User with external_id: #{external_id} not found"
      else
        Rails.logger.info "UserUpdateConsumer: User #{user.id} not updated due to errrors #{user.errors.full_messages}"
      end
    end
  end
end
