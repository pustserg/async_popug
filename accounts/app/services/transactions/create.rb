# check homework week3

module Transactions
  class Create
    include Interactor

    delegate :params, :kind, to: :context

    def call
      transaction = Transaction.new(transaction_params)
      if transaction.save
        Rails.logger.info "TaskAssignedConsumer: Transaction #{transaction.id} saved successfully"
        Producer.publish('transaction_created', transaction.as_json(except: %i[id created_at updated_at]))
      else
        Rails.logger.error "TaskAssignedConsumer: Transaction save failed due to errors #{transaction.errors.full_messages}"
      end
    end

    private

    def transaction_params
      {
        public_id: params['public_id'],
        task_public_id: params['public_id'],
        user_id: user&.id,
        kind: kind,
        amount: amount(kind),
        memo: "#{params['title']} #{params['description']} #{params['jira_id']}"
      }
    end

    def amount(kind)
      kind == Transaction.kinds[:income] ? params['finish_price'] : params['assign_price']
    end

    def user
      @user ||= User.find_by(public_id: params['user_id'])
    end
  end
end
