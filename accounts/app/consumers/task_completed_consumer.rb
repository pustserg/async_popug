# check homework week3

class TaskCompletedConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      Rails.logger.info "TaskCompletedConsumer: #{message}"
      message_body = JSON.parse(message.value)
      Transactions::Create.call(params: message_body['data'], kind: Transaction.kinds[:income])
    end
  end
end
