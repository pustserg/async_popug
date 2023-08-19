# check homework week3

class TaskAssignedConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      Rails.logger.info "TaskAssignedConsumer: #{message}"
      message_body = JSON.parse(message.value)
      Transactions::Create.call(params: message_body['data'], kind: Transaction.kinds[:outcome])
    end
  end
end
